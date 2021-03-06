package com.cplatform.mall.back.websys.web;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.cplatform.dbhelp.page.Page;
import com.cplatform.mall.back.item.web.ItemManageController;
import com.cplatform.mall.back.utils.AppConfig;
import com.cplatform.mall.back.utils.JsonRespWrapper;
import com.cplatform.mall.back.utils.LogUtils;
import com.cplatform.mall.back.websys.dao.SysAdDao;
import com.cplatform.mall.back.websys.dao.SysAdPositionDao;
import com.cplatform.mall.back.websys.entity.SysAd;
import com.cplatform.mall.back.websys.entity.SysAdPosition;
import com.cplatform.mall.back.websys.service.BsFileService;
import com.cplatform.mall.back.websys.service.SysAdService;
import com.cplatform.util2.FileTools;
import com.cplatform.util2.TimeStamp;
/**
 * 
 * 广告位置管理控制器. <br>
 * 类详细说明.
 * <p>
 * Copyright: Copyright (c) 2013-5-28 上午11:20:06
 * <p>
 * Company: 北京宽连十方数字技术有限公司
 * <p>
 * @author zhaowei@c-platform.com
 * @version 1.0.0
 */
@Controller
@RequestMapping(value = "/websys/ad")
public class SysAdPositionController {
	@Autowired
	private LogUtils logUtils;
	
	@Autowired
	private SysAdPositionDao sysAdPositionDao;
	
	@Autowired
	private SysAdService sysAdService;
	
	@Autowired
	private AppConfig appConfig;
	
	@Autowired
	private BsFileService bsFileService;
	
	private static final Logger log = Logger.getLogger(ItemManageController.class);
	@Autowired
	private SysAdDao sysAdDao;
    
	/**
	 * 广告位置查询列表
	 * @param adPosition    广告位置实体类
	 * @param page    当前页
	 * @param model
	 * @return
	 * @throws SQLException
	 */
    @RequestMapping(value="/position_list")
    public String list(SysAdPosition adPosition, @RequestParam(value = "page", required = false, defaultValue = "1") int page, Model model) throws SQLException {
    	Page<SysAdPosition> adPositionPage = sysAdService.findSysAdPosition(adPosition, page);
    	model.addAttribute("adPosition", adPosition);
    	model.addAttribute("adPositionPage", adPositionPage);
    	model.addAttribute("typeMap", SysAdPosition.getTypeMap());
        return "websys/ad/ad_position_list";
    }
    
    /**
     * 跳转添加
     * @param model
     * @return
     */
    @RequestMapping(value = "/position_add", method = RequestMethod.GET)
	public String add(Model model) {
		SysAdPosition sysAdPosition = new SysAdPosition();
		model.addAttribute("method", "add");
		model.addAttribute("sysAdPosition", sysAdPosition);
		model.addAttribute("typeMap", SysAdPosition.getTypeMap());
		return "websys/ad/ad_position_add";
	}
    /**
     * 添加广告位置
     * @param uploadFile    模板文件
     * @param sysAdPosition    广告位置实体类
     * @param request
     * @param result
     * @return
     */
    @RequestMapping(value = "/position_add", method = RequestMethod.POST)
	@ResponseBody
	public Object createPost(MultipartFile uploadFile, @ModelAttribute("sysAdPosition") SysAdPosition sysAdPosition, HttpServletRequest request, BindingResult result) {
//    	if (null == uploadFile) {
//			// 提示用户必须要上传文件
//			return JsonRespWrapper.successAlert("请选择模板文件。");//弹出提示
//		}
    	if("1".equals(sysAdPosition.getPosition())){
    		sysAdPosition.setPosition("home");
    	}else if("2".equals(sysAdPosition.getPosition())){
    		sysAdPosition.setPosition("search");
    	}else{
    		sysAdPosition.setPosition("item");
    	}
    	try {
			// 执行业务逻辑
    
    		sysAdService.saveAdPosition(sysAdPosition, uploadFile);
    		logUtils.logAdd("添加广告位置","添加成功");

    		String backUrl = request.getParameter("backUrl");
    		return JsonRespWrapper.success("操作成功", backUrl);

		}
		catch (Exception ex) {
			log.error(ex.getMessage());
			logUtils.logAdd("添加广告位置","添加成功");
			// 未知的错误消息，一般是exception catch后通知用户
			return JsonRespWrapper.error(ex.getMessage());
		}
    }
    
    /**
     * 跳转编辑
     * @param id    待编辑广告位置ID
     * @param model
     * @return
     */
    @RequestMapping(value = "/position_edit", method = RequestMethod.GET)
	public String edit(@RequestParam(required = false) Long id, Model model) {
		SysAdPosition sysAdPosition = sysAdPositionDao.findOne(id);
		model.addAttribute("method", "edit");
		model.addAttribute("sysAdPosition", sysAdPosition);
		model.addAttribute("typeMap", SysAdPosition.getTypeMap());
		return "websys/ad/ad_position_add";
	}    
    /**
     * 编辑广告位置
     * @param uploadFile    模板文件
     * @param sysAdPosition    广告位置实体类
     * @param request
     * @param result
     * @return
     */
    @RequestMapping(value = "/position_edit", method = RequestMethod.POST)
	@ResponseBody
	public Object updatePost(MultipartFile uploadFile, @ModelAttribute("sysAdPosition") SysAdPosition sysAdPosition, HttpServletRequest request, BindingResult result) {
    	try {
    		//判断是否需要删除原模板文件
//			if(null != uploadFile){
//    			File fileOld = new File(sysAdPosition.getTemplateFile());
//    			if(fileOld.exists()){
//    				fileOld.delete();
//    			}
//	    	}
    		if("1".equals(sysAdPosition.getPosition())){
        		sysAdPosition.setPosition("home");
        	}else if("2".equals(sysAdPosition.getPosition())){
        		sysAdPosition.setPosition("search");
        	}else{
        		sysAdPosition.setPosition("item");
        	}
			// 执行业务逻辑
    	
    		sysAdService.saveAdPosition(sysAdPosition, uploadFile);
    		logUtils.logModify("编辑广告位置","操作成功，广告编号："+sysAdPosition.getId());
    		String backUrl = request.getParameter("backUrl");
    		return JsonRespWrapper.success("操作成功", backUrl);

		}
		catch (Exception ex) {
			logUtils.logModify("编辑广告位置","操作成功，广告编号："+sysAdPosition.getId());
			log.error(ex.getMessage());
			// 未知的错误消息，一般是exception catch后通知用户
			return JsonRespWrapper.error(ex.getMessage());
		}
    }

    /**
     * 广告位置删除
     * @param id    待删除广告位置
     * @return
     */
    @RequestMapping(value = "position_delete/{id}")
	@ResponseBody
	public Object deleteAdPosition(@PathVariable Long id) {
    	List<SysAd> sysAdList = sysAdDao.findByPositionId(id);
    	if(0 < sysAdList.size()){
    		return JsonRespWrapper.successAlert("该广告位置下有多个广告，不能被删除！");
    	}
    	SysAdPosition sysAdPosition = sysAdPositionDao.findOne(id);
    	//删除相应文件
//    	if(null != sysAdPosition.getTemplateFile()){
//    		File file = new File(sysAdPosition.getTemplateFile());
//			if(file.exists() && file.isFile()){
//				file.delete();
//			}
//    	}
    	sysAdPositionDao.delete(id);
		logUtils.logModify("删除广告位置","操作成功，广告编号："+id);
    	return JsonRespWrapper.successReload("删除成功！");
	}
    
    /**
     * 下载模板文件
     * @param id
     * @param request
     * @param response
     * @return
     * @throws IOException
     * @throws Exception
     */
	@RequestMapping(value = "/downfile/{id}")
	public ModelAndView downFile(@PathVariable Long id, HttpServletRequest request, HttpServletResponse response) throws IOException, Exception {
		SysAdPosition sysAdPosition = sysAdPositionDao.findOne(id);
//		if (null != sysAdPosition.getTemplateFile()) {
//			File file = new File(sysAdPosition.getTemplateFile());
//			String fileName = file.getName();
//			bsFileService.download(request, response, sysAdPosition.getTemplateFile().toString(), "adp_mbwj_" + fileName);
//		}
		return null;
	}
}
