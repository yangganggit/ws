package com.cplatform.mall.back.store.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cplatform.dbhelp.page.Page;
import com.cplatform.mall.back.entity.AuditStep;
import com.cplatform.mall.back.model.SessionUser;
import com.cplatform.mall.back.store.entity.Store;
import com.cplatform.mall.back.store.service.StoreService;
import com.cplatform.mall.back.store.web.validator.StoreValidator;
import com.cplatform.mall.back.sys.dao.SysRegionDao;
import com.cplatform.mall.back.sys.entity.SysRegion;
import com.cplatform.mall.back.sys.service.SysRegionService;
import com.cplatform.mall.back.utils.JsonRespWrapper;
import com.cplatform.mall.back.utils.LogUtils;
import com.cplatform.mall.back.websys.entity.SysLogistics;
import com.cplatform.util2.TimeStamp;

/**
 * 
 * @Title 非结算商户控制层
 * @Description
 * @Copyright: Copyright (c) 2013-9-18
 * @Company: 北京宽连十方数字技术有限公司
 * @Author chencheng
 * @Version: 1.0
 *
 */
@Controller
@RequestMapping(value = "/store/store")
public class NonStoreController {
	private static Logger log = Logger.getLogger(NonStoreController.class);
	@Autowired
	private SysRegionDao sysRegionDao;

	@Autowired
	private SysRegionService sysRegonService;

	@Autowired
	private StoreService storeService;

	@Autowired
	private StoreValidator storeValidator;
	
	@Autowired
	private LogUtils logUtils;

	/**
	 * 列表显示商户信息
	 * 
	 * @param contentCode
	 * @param page
	 * @param model
	 * @return
	 * @throws SQLException
	 */
	@RequestMapping(value = "/nonList")
	public String nonStoreList(Store store, @RequestParam(value = "page", required = false, defaultValue = "1") int page, Model model)
	        throws SQLException {
		store.setSort(0L);
		store.setIsValid(1L);
		store.setShopClass(2L);
		Page<Store> storeList = storeService.listStore(store, page, Page.DEFAULT_PAGESIZE, "", "");
		//设置审核时间
		storeList=storeService.setStorePage(storeList);
		model.addAttribute("pageData", storeList);
		model.addAttribute("storeClassMap", Store.shopClassMap);
		model.addAttribute("isValidMap", Store.isValidMap);
		model.addAttribute("syncGyFlagMap", Store.syncGyFlagMap);
		model.addAttribute("statusMap", Store.statusMap);
		model.addAttribute("syncGyFlagMsg", Store.syncGyFlagMsg);
		return "/store/store/nonstore-list";
	}

	/**
	 * 点击进入商户基本信息查看
	 */
	@RequestMapping(value = "/noneStoreView/{id}")
	public String storeView(@PathVariable Long id, @RequestParam(value = "auditStep", required = false) String auditStep, Model model)
	        throws SQLException {
		Store store = this.storeService.findStoreById(id);
		List<AuditStep> auditStepList = this.storeService.findShopAuditSteplist(store.getId());
		SysRegion sysRegon = sysRegonService.findByRegionCode(store.getAreaCode());
		store.setAreaName(sysRegon.getRegionName());
		model.addAttribute("store", store);
		model.addAttribute("auditStepList", auditStepList);
		return "/store/store/nonestore-view";
	}

	/**
	 * 进入商户增加页面
	 * 
	 * @param model
	 * @return
	 * @throws IOException
	 * @throws Exception
	 */
	@RequestMapping(value = "/nonStoreAdd", method = RequestMethod.GET)
	public String nonStoreAddPage(Model model) throws IOException, Exception {
		Store store = new Store();
		model.addAttribute("store", store);
		// 跳转到列表页面
		List<SysLogistics> logisticsList = storeService.findSysLogisticsList();
		model.addAttribute("logisticsList", logisticsList);
		model.addAttribute("pid", SessionUser.getSessionUser().getSysUnit().getAreaCode());
		if (SessionUser.getSessionUser().getSysUnit().getUnitType() == 3L) {// 如果是地址单位，设置归属地址和行政编码的默认值
			store.setAreaCode(SessionUser.getSessionUser().getSysUnit().getAreaCode());
			store.setAreaName(SessionUser.getSessionUser().getSysUnit().getName());
			store.setAreaId(SessionUser.getSessionUser().getSysUnit().getAreaCode());
		}
		return "/store/store/nonstore-add";
	}

	/**
	 * 完成商户增加
	 * 
	 * @param model
	 * @return
	 * @throws IOException
	 * @throws Exception
	 */
	@RequestMapping(value = "/nonStoreAdd", method = RequestMethod.POST)
	@ResponseBody
	public Object storeSave(@ModelAttribute("store") Store store, Model model, HttpServletRequest request, BindingResult result) throws IOException,
	        Exception {
		storeValidator.validate(store, result);
		if (result.hasErrors()) {
			return JsonRespWrapper.error(result.getFieldErrors());
		}
		store.setCreateTime(TimeStamp.getTime(14));
		store.setUpdateUserId(SessionUser.getSessionUser().getId());
		store.setStatus(Store.STATUS_NO_AUDIT);
		store.setIsValid(1l);
		store.setSyncGyFlag(0l);
		store.setShopClass(2L);
		store.setItemEditAuditFlag(0L);
		store.setItemPublishAuditFlag(0L);
		store.setShopEditAuditFlag(0L);
		storeService.saveUpdateStore(store);
		logUtils.logAdd("非结算商户管理", "非结算商户添加, 非结算商户编号：" +store.getId());
		return JsonRespWrapper.success("操作成功", "/store/store/nonList");
	}

	/**
	 * 进入商户修改页面
	 * 
	 * @param id
	 * @param model
	 * @return
	 * @throws SQLException
	 */
	@RequestMapping(value = "/nonStoreEdit", method = RequestMethod.GET)
	public String storeEdit(@RequestParam Long id, Model model) throws SQLException {
		// 得到商户
		// Store store = storeService.findStoreById(id);
		// model.addAttribute("store", store);
		Store store = storeService.findStoreById(id);

		SysRegion region = this.sysRegonService.findByRegionCode(store.getAreaCode());
		// 行政区域 名称
		model.addAttribute("areaIdRegion", sysRegionDao.findByRegionCode(store.getAreaId()));

		if (region != null) {
			store.setAreaName(region.getRegionName());
			System.out.println(region.getRegionName());
		}
		model.addAttribute("pid", SessionUser.getSessionUser().getSysUnit().getAreaCode());
		model.addAttribute("store", store);

		return "/store/store/nonstore-edit";
	}

	/**
	 * 完成商户修改
	 * 
	 * @param id
	 * @param model
	 * @return
	 * @throws SQLException
	 */
	@RequestMapping(value = "/nonStoreEdit", method = RequestMethod.POST)
	@ResponseBody
	public Object storeUpdate(@ModelAttribute("store") Store store, Model model, HttpServletRequest request, BindingResult result)
	        throws SQLException, IOException {
		Store oldstore = this.storeService.findStoreById(store.getId());
		store.setUpdateUserId(SessionUser.getSessionUser().getId());
		store.setUpdateTime(TimeStamp.getTime(TimeStamp.YYYYMMDDhhmmss));
		store.setCreateTime(oldstore.getCreateTime());
		store.setShopClass(oldstore.getShopClass());
		store.setIsValid(oldstore.getIsValid());
		store.setSyncGyFlag(oldstore.getSyncGyFlag());
		store.setMerchid(oldstore.getMerchid());
		store.setSysUserId(oldstore.getSysUserId());
		store.setStatus(1l);
		if (store.getShopClass() == Store.CHANNEL) {
			store.setShopEditAuditFlag(oldstore.getShopEditAuditFlag());
		}
		store.setSort(oldstore.getSort());
		store.setItemEditAuditFlag(0L);
		store.setItemPublishAuditFlag(0L);
		store.setShopEditAuditFlag(0L);
		storeService.saveUpdateStore(store);
		// return JsonRespWrapper.success("操作成功", "/store/store/nonList");
		// 返回到来源页面
		String backUrl = request.getParameter("backUrl");
		logUtils.logModify("非结算商户管理", "非结算商户修改, 非结算商户编号：" +store.getId());
		return JsonRespWrapper.success("操作成功", backUrl);

	}

	/**
	 * 删除商户（逻辑删除）
	 * 
	 * @param id
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/nonStoreDel/{id}")
	@ResponseBody
	public Object storeDel(@PathVariable(value = "id") Long id, Model model) {
		Store store = this.storeService.findStoreById(id);
		store.setIsValid(0L);
		storeService.saveUpdateStore(store);
		logUtils.logDelete("非结算商户管理", "非结算商户删除, 非结算商户编号：" +store.getId());
		return JsonRespWrapper.success("删除成功", "javascript:window.location.reload()");
	}

	/**
	 * 获取待审核商户页面信息
	 * 
	 * @param store
	 * @param page
	 * @param model
	 * @return
	 * @throws SQLException
	 */
	@RequestMapping(value = "/nonAuditList")
	public String auditList(@ModelAttribute("store") Store store, @RequestParam(value = "page", required = false, defaultValue = "1") int page,
	        Model model) throws SQLException {
		store.setStatus(1L);
		store.setSort(0L);
		Page<Store> storeList = storeService.listStore(store, page, Page.DEFAULT_PAGESIZE, "", "");
//		storeList=storeService.setStorePage(storeList);
		model.addAttribute("pageData", storeList);
		model.addAttribute("status", 1L);
		model.addAttribute("storeClassMap", Store.shopClassMap);
		// model.addAttribute("shopClass", shopClass);
		return "/store/store/nonstore-audit";

	}

	/**
	 * 送审
	 * 
	 * @param model
	 * @return
	 * @throws SQLException
	 */
	@RequestMapping(value = "/nonAudit/{id}")
	@ResponseBody
	public Object audit(@PathVariable Long id, HttpSession session, Model model) {
		Store store = this.storeService.findStoreById(id);
		store.setStatus(Store.STATUS_NO_AUDIT);
		String msg="送审失败";
		try {
			msg = storeService.auditStore(store, null);
		} catch (SQLException e) {
			log.error("送审失败:"+e.getMessage());
		}
		// return JsonRespWrapper.success(msg, "/store/store/nonList");
		return JsonRespWrapper.successReload(msg);
	}

	/**
	 * 跳转到审核页面
	 * 
	 * @param id
	 * @param auditStep
	 * @param status
	 * @param model
	 * @return
	 */

	@RequestMapping(value = "/noneAuditPage")
	public String toAuditPage(@RequestParam(value = "id") Long id, @RequestParam(value = "auditStep") String auditStep,
	        @RequestParam(value = "status") Long status, Model model) {
		model.addAttribute("id", id);
		model.addAttribute("status", status);
		model.addAttribute("auditStep", auditStep);
		return "/store/store/nonstore-auditing";
	}

	/**
	 * 审核商户
	 * 
	 * @param model
	 * @return
	 * @throws SQLException
	 */
	@RequestMapping(value = "/nonStoreAudit")
	@ResponseBody
	public Object storeAudit(@RequestParam(value = "id") Long storeId, @ModelAttribute("step") AuditStep step,
	        @RequestParam(value = "status") Long status, @RequestParam(value = "auditStep") String auditStep, Model model) {
		Store store = this.storeService.findStoreById(storeId);
		//保存非结算商户审核信息,modify by chen start >>>
		store.setStatus(status);
		step.setStatus(store.getStatus());
		step.setAuditUserId(SessionUser.getSessionUser().getId());
		step.setBsType(store.getShopClass());
		step.setUpdateTime(TimeStamp.getTime(14));
		step.setBsId(storeId);
		step.setBsTabel("T_STORE");
		step.setStatus(store.getStatus());
		String msg = storeService.auditNoneStore(store, step);
		//<<<end
		logUtils.logAudit("非结算商户管理", "非结算商户审核, 非结算商户编号：" +store.getId());
		return JsonRespWrapper.success(msg, "/store/store/nonAuditList");
	}

}
