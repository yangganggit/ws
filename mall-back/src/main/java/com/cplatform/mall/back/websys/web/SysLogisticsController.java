package com.cplatform.mall.back.websys.web;

import java.sql.SQLException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cplatform.dbhelp.page.Page;
import com.cplatform.mall.back.utils.JsonRespWrapper;
import com.cplatform.mall.back.utils.LogUtils;
import com.cplatform.mall.back.websys.entity.SysLogistics;
import com.cplatform.mall.back.websys.service.SysLogisticsService;

/**
 * 物流信息控制类 Title. <br>
 * Description.
 * <p>
 * Copyright: Copyright (c) 2013-6-4 下午5:36:10
 * <p>
 * Company: 北京宽连十方数字技术有限公司
 * <p>
 * Author: LiuDong@c-platform.com
 * <p>
 * Version: 1.0
 * <p>
 */
@Controller
@RequestMapping("/websys/logistics")
public class SysLogisticsController {

	@Autowired
	private LogUtils logUtils;

	@Autowired
	private SysLogisticsService sysLogisticsService;

	@RequestMapping(value = "list")
	public String findLogistics(@ModelAttribute("sysLogistics") SysLogistics sysLogistics,
	        @RequestParam(value = "page", required = false, defaultValue = "1") int page, Model model) throws SQLException {
		Page<SysLogistics> pageData = this.sysLogisticsService.findSysLogistics(sysLogistics, page, Page.DEFAULT_PAGESIZE);
		model.addAttribute("pageData", pageData);
		return "/websys/logistics/list";
	}

	@RequestMapping(value = "/add", method = RequestMethod.GET)
	public String add(Model model) {
		SysLogistics sysLogistics = new SysLogistics();
		model.addAttribute("sysLogistics", sysLogistics);
		return "/websys/logistics/add";
	}

	@RequestMapping(value = "/add", method = RequestMethod.POST)
	@ResponseBody
	public Object save(@ModelAttribute("sysLogistics") SysLogistics sysLogistics, Model model) {
	
		this.sysLogisticsService.addOrUpdateSysLogistics(sysLogistics);
		logUtils.logAdd("添加物流信息","添加成功!，物流编号："+sysLogistics.getId());
		return JsonRespWrapper.success("操作成功", "/websys/logistics/list");
	}

	@RequestMapping(value = "/edit", method = RequestMethod.GET)
	public String edit(@RequestParam(value = "id") Long id, Model model) {
		SysLogistics sysLogistics = this.sysLogisticsService.findSysLogisticsById(id);
		model.addAttribute("sysLogistics", sysLogistics);
		return "/websys/logistics/add";
	}

	@RequestMapping(value = "/edit", method = RequestMethod.POST)
	@ResponseBody
	public Object update(@ModelAttribute("sysLogistics") SysLogistics sysLogistics, Model model) {
	
		this.sysLogisticsService.addOrUpdateSysLogistics(sysLogistics);
		logUtils.logAdd("编辑物流信息","添加成功!，物流编号："+sysLogistics.getId());
		return JsonRespWrapper.success("操作成功", "/websys/logistics/list");
	}
	
	@RequestMapping(value = "/view", method = RequestMethod.GET)
	public String view(@RequestParam(value = "id") Long id, Model model) {
		SysLogistics sysLogistics = this.sysLogisticsService.findSysLogisticsById(id);
		model.addAttribute("sysLogistics", sysLogistics);
		return "/websys/logistics/view";
	}

	@RequestMapping(value = "/del")
	@ResponseBody
	public Object del(@RequestParam(value = "id") Long id) {
		this.sysLogisticsService.delSysLogisticsById(id);
		logUtils.logAdd("删除物流信息","删除成功!，物流编号："+id);
		return JsonRespWrapper.success("操作成功", "/websys/logistics/list");
	}
}
