<%@ page language="java" pageEncoding="utf-8"%>
<%@ include file="../../includes/importer.jsp"%>
<!doctype html>
<html>
<head>
<head>
<ht:head />

<script type="text/javascript">
    
 
      function iseckchange(value){   
          if(value==1){
          document.getElementById("iseckillPrice1").style.display ='block';
          }else{
          document.getElementById("iseckillPrice1").style.display ='none';
          }
      }
    
    </script>


<script type="text/javascript">

          

         	  $(function(){
        if($("#select option[value=${sale.iseckill}]").val()==1){
     
         
         	  $("#iseckillPrice1").css("display","block");
         	 }else{
         	 
         	   $("#iseckillPrice1").css("display","none");
         	 
         	 }
         	
         	  })

 $(document).ready(function(){
 	 //获取来源地址
 
	 var url = document.referrer;
	 $("#backUrl").val(url);
	 $("#parameterId").load("${ctx}/item/item/loadProperty/"+${sale.typeId}+"/"+${store.id}+"?itemId="+${sale.id});
    	
    	//选择商品分类
    	selectItemType("#typeName",function(id,txt){
    		$("#typeId").val(id);
    		$("#typeName").val(txt);
    		//加载分类属性
    		 $("#parameterId").load("${ctx}/item/item/loadProperty/"+id+"/"+${store.id}+"?itemId="+${sale.id});
    	});
    	
    	$(document).ready(function(){
    	 if($("#unlimitedStockNum").attr("checked")=="checked"){
    			 $("#stockNum").attr({ readonly: 'true' });  
    			 $("#stockNum").val("999999999");
    			 }else{
    	        	
    	        	$("#stockNum").removeAttr("readonly");    	
    	        }
    	
    	});
    	
    
    	
    	//选择商户
    	$("#storeName").click(function(){
			selectStore("storeId","storeName","shopClass");
		});
    	
    	//商品类型
		$("input[type='radio'][name='itemMode']").click(function(){
			if(this.value==1){
				//$("#virtualTypeView").show();
				//$("input[type='radio'][name='virtualType'][value='${sale.virtualType}']").attr("checked",true);//

				$("#sendCodeMode").val("2");
				$("#selSendCode").show();
				$("#selLogistics").hide(); 
				$("#div_saleShopName").show();
			}else{
				//选择实物时，把虚拟产品类型置为不选中
				//$("input[type='radio'][name='virtualType']").attr("checked",false);//
				//$("#virtualTypeView").hide();

				$("#sendCodeMode").val("0");
				$("#selLogistics").show(); 
				$("#selSendCode").hide();
				$("#div_saleShopName").hide()
			}
		});
		

		//增加商品属性
		$("#add").click(function() { 
    		var html=      "<div class='dl' ><br />"+
            "<div class='dt class='req'>"+
            "  <select name='propertyId'>"+
             "   <c:forEach items='${sysPropertyList}' var='item' varStatus='index'>"+
              "   <option value='${item.id}'>${item.content}</option>"+
                " </c:forEach>"+
               " </select>："+
           "</div>"+
           "<div class='dd'>"+
           "  <input type='hidden'  name='flag' id='flag' value='0'/>"+
           "    <input type='text'  name='itemProperyName' maxlength='100' class='small required'/>"+
           "   <input class=\"file\" style=\"display: inline; width: 250px;\"></input>"+
          // "    <input type='file'  "+
           //"    class=\"validation-passed\" style=\"position: relative; height: 28px; width: 250px; display: inline; cursor: pointer; opacity: 0; margin-left: -142px;\" "+
         //  "     name='uploadPropertyPic' size='40' />"+
           " <a class=\"ui-input-file\"><input type=\"file\" size=\"40\" re=\"\" name=\"uploadPropertyPic\" style=\"position: relative; height: 28px; width: 250px; display: inline; cursor: pointer; opacity: 0; margin-left: -142px;\" ></input></a>"+
           "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+
           "      <a href='javascript:void(0);' id='del' onclick='delDiv(this)' title='删除'><font color='red'>删除</font></a>"+
           "    <span class='error' id='advice-required-itemProperyName' style='display:none'></span>"+
          " </div>"
      " </div>"; 
    		 $('#divAdd').append(html); 
    	});	
    	//增加自定义参数
    	$("#addpara").click(function() { 
    		var html= "<div class='dl'><br /><span style='float:left'>参数名称：</span><input type='text' name='customparakey' class='required'  maxlength='10'/><span style='float:left'>参数值:</span><input type='text' name='customparavalue' class='required'  maxlength='10'/>"+
    		"<a href='javascript:void(0);' id='del' onclick='delpara(this)' title='删除'><font color='red'>删除</font></a></div>";
    		 $('#divAddpara').append(html); 
    	});
    	
    	//码验证方式 @add_by macl@c-platform.com
        $(':radio[name="radio-verify"]').click(function(){
            var val = $(':radio[name="radio-verify"]:checked').val();
			if(val==0){
				$("#verifyTime").show();
	    		$("#verifyDays").hide();
	    		$("#verifyDay").val("");
			}else{
				$("#verifyDays").show();
				$("#verifyTime").hide();
				$("#verifyStartTime").val("");
				$("#verifyStopTime").val("");
			}
        });
	
    	
    	//是否需要物流触发的事件
        $(':radio[name="postFlag"]').click(function(){
    	    var val= $(':radio[name="postFlag"]:checked').val(); 
    	    if(val==0) {//选择不发码
    	    	$("#logisticsFeeType").attr("checked",'');//
    		    $("#isPost").hide();
    		    $("#postArea").val(""); 
    		    $("#postAreaCode").val("");
    		    $("#logisticsFee").val("");
    	    }
    	    if(val==1){
    		    $("#isPost").show();  
    		    $("#logisticsFeeType").attr("checked",true);//
    		    $("#postArea").val('${sale.postArea}'); 
    		    $("#postAreaCode").val('${sale.postAreaCode}');
    		    $("#logisticsFee").val('${sale.logisticsFee}');
    	    }
        });
    	
      //发码方式触发的事件
        $(':radio[name="sendCodeMode"]').click(function(){
    	    var val= $(':radio[name="sendCodeMode"]:checked').val(); 
    	    if(val==0) {//选择不发码
    		    $("#selLogistics").show(); 
    		    $("#selSendCode").hide();
    		    //发码方式
    		    $("input[type='radio'][name='verifyCodeType']").attr("checked",false);
    		    //发码方设置
    		    $("input[type='radio'][name='sendCodeChannel']").attr("checked",false);
    		    //验证开始时间
    		    $("#verifyStartTime").val("");
    		    //验证结束时间
    		    $("#verifyStopTime").val("");
    		    //验证天数
    		    $("#verifyDay").val("");
    		    //验证门店设置空
    		    $("#verifyShopName").val("");
    		    $("#verifyShopIds").val("");
    		    //制码渠道
    		    $("#select option[value='']").attr("selected","selected");
    		    
    		    
    		    $("#postArea").val('${sale.postArea}');
    		    $("#postAreaCode").val('${sale.postAreaCode}');
    		    $("#logisticsFee").val('${sale.logisticsFee}');
    		    
    	    }else{
    		    $("#selLogistics").hide(); 
    		    $("#selSendCode").show();  
    		    //是否需要物流
    		    $("input[type='radio'][name='postFlag']").attr("checked",false);
    		    //配送区域
    		    $("#postArea").val("");
    		    $("#postAreaCode").val("");
    		    $("#logisticsFee").val("");
    		    
    		    
    		  //验证开始时间
    		    $("#verifyStartTime").val('${sale.verifyStartTime}');
    		    //验证结束时间
    		    $("#verifyStopTime").val('${sale.verifyStopTime}');
    		    //验证天数
    		    $("#verifyDay").val('${sale.verifyDay}');
    		    //验证门店设置空
    		    $("#verifyShopName").val('${sale.verifyShopName}');
    		    $("#verifyShopIds").val('${sale.verifyShopIds}');
    		    //制码渠道
    		    $("#select option[value=${sale.sendCodeSrc}]").attr("selected","selected");
    		    
    	    }
        });
        
      //发码方设置触发的事件
        $(':radio[name="sendCodeChannel"]').click(function(){
    	    var val= $(':radio[name="sendCodeChannel"]:checked').val(); 
    	    if(val==2) {
    		    $("#sendCodeSrcId").show(); 
    	    }else{
    		    $("#sendCodeSrcId").hide(); 
    		  //制码渠道
    		    $("#select option[value='']").attr("selected","selected");
    	    }
        });
      
        $(':checkbox[name="buyLimit"]').click(function(){
        	 if($("#checkbox-1").attr("checked")){
        		 $("#userLimit").show(); 
        	 }else{
        		 $("#userLimit").hide(); 
        		 $("input[type='checkbox'][name='userLimitCode']").attr("checked",false);
        		 
        	 }
        	 if($("#checkbox-2").attr("checked")){
        		 $("#areaLimit").show(); 
        	 }else{
        		 $("#areaLimit").hide(); 
        		 $("#areaLimitName").val("");
     		    $("#areaLimitCode").val("");
        	 }
        	 if($("#checkbox-3").attr("checked")){
        		 $("#numLimit").show(); 
        	 }else{
        		 $("#numLimit").hide(); 
        		 $("#userPerBuyNum").val("");
        	 }
        });
        
    	$("#saleShopName").click(function(){
    		var storeId=$("#storeId").val();
        	if(storeId==""){
        		alert("请选择商户！");
        		$("#storeName").focus();
        		return;
        	}
    		selectShop(storeId,$("#saleShopIds").val(),function(ids,txts){
        		$('#saleShopIds').val(ids.join(","));
        		$('#saleShopName').val(txts.join(","));
        	});
    			
    	});
    	$("#verifyShopName").click(function(){
    		var storeId=$("#storeId").val();
        	if(storeId==""){
        		alert("请选择商户！");
        		$("#storeName").focus();
        		return;
        	}
    	    selectShop(storeId,$("#verifyShopIds").val(),function(ids,txts){
        		$('#verifyShopIds').val(ids.join(","));
        		$('#verifyShopName').val(txts.join(","));
        	});
        	$('#verifyShopName').focus();
        	$('#verifyShopName').blur();
    			
    	});
    	//配送区域
    	selectRegion("#postArea","postAreaCode","postArea",0,{index:1});
    	//购买区域
    	selectRegion("#areaLimitName","areaLimitCode","areaLimitName",0,{index:2});
    	//销售区域
    	var oldhtml="";
    	selectRegionCallBack("#saleAreaName",function(saleAreaCode,saleAreaName){
    		if(oldhtml==""){
    			oldhtml=$("#priceId").html();
    		}
    		$("#saleAreaCode").val(saleAreaCode);
    		$("#saleAreaName").val(saleAreaName);
    		if(saleAreaCode=='${sale.saleAreaCode}'){
   			 $("#priceId").html(oldhtml);
	   		}else{
		   		/*
	    		//提交Ajax获取该区域的价格设置
	    		$.ajax({
	    			   type: "POST",
	    			   url: "${ctx}/item/item/getPrice/"+saleAreaCode,
	    			   cache: false,
	    			   dataType:"json",
	    			   success: function(msg){
	    				   var htmlStr="<table    id='TbData' name='TbData'  cellpadding='0' cellspacing='0' >";
	    				   for(var i=0;i<msg.length;i++){
	    					   htmlStr=htmlStr+"<tr >"
	    						   +"<td align='right'>"+msg[i].priceType+":</td><td><input  name='priceTypeCode'  type='hidden' value='"+msg[i].priceTypeCode+"' /><input  name='price' value='0' class=' required validate-number' type='text' value='0' maxlength='50' />元</td>"
	    						   +"</tr>";
	    		    	  }
	    				   htmlStr=htmlStr+" </table><span class='error' id='advice-required-price' style='display:none'></span>";
	    				   
	    				   $("#priceId").html(htmlStr);
	    			   }
	    			});
    			*/
	   		}

    	},0,{index:3/*,maxItems:1*/});
    	//选择品牌
    	$("#brand").click(function(){
    	  selectBrand("brand");
    	  });
    	//选择货架类型
    	selectStoreShelf("#goodTypeName","storeId",function(id,name){
    		 $("#goodTypeName").val(name);
    		 $("#goodTypeId").val(id);
    	});
    	//设置库存不限操作
    	$("#unlimitedStockNum").click(function(){
    		
    		 if($("#unlimitedStockNum").attr("checked")=="checked"){
    			 $("#stockNum").attr({ readonly: 'true' });  
    			 $("#stockNum").val("999999999");
    	        }else{
    	        	
    	        	$("#stockNum").removeAttr("readonly");    	
    	        }

    		
    	});
    	//删除商品属性
    	$(".item_del").click(function() { 
    		if(confirm("是否将此属性删除?")){
    		var id = $(this).attr("id");
    		$.ajax({
    			type : "POST",
    			url : "${ctx}/item/item/deleteItemPropertyAjax/"+id,
    			cache : false,
    			dataType : "json",
    			success : function(r) {
    				simpleAlert(r.message,function() {
    					$(this).parent().remove();
    				});
    			}
    		});
    		}
    	});
    	
    	//选择货架类型
    	selectStoreShelf("#goodTypeName","storeId",function(id,name){
    		 $("#goodTypeName").val(name);
    		 $("#goodTypeId").val(id);
    	});
    	
	});	
    
         	  
         	 function clickUserLimit(object){
         		if($("#" + object).val() != 0){
         			$("#" + object).val('0');
         		}else{
         			$("#" + object).val('');
         		}
             	if($("#vali" + object).text() == '请输入正确金额'  || $("#vali" + object).text() == '请输入值'){
             		$("#" + object).val('0');
             	}
             	if($("#" + object).val() == ''){
             		$("#vali" + object).text('请输入值');
             		$("#submitButton").attr("disabled","true");
             	}else{
             		$("#vali" + object).text('');
             		$("#submitButton").removeAttr("disabled");
             	}
             	
         	}
             
             function blurUserLimit(object){
             	var value = $("#" + object).val();
             	var pattern = /^[+-]?\d*\.?\d{1,2}$/;
             	if(pattern.test(value) == false){
             		$("#vali" + object).text('请输入正确金额');
             		$("#submitButton").attr("disabled","true");
             	}else{
             		$("#vali" + object).text('');
             		$("#submitButton").removeAttr("disabled");
             	}
         			
             }
             
         	  
         	  
    function sub(){
    	var obj = document.getElementsByName("flag");
    	var picObj =  document.getElementsByName("uploadPropertyPic");
    	for(var i=0;i<obj.length;i++){
    		if(picObj[i].value !='' && picObj[i].value!=null){
    			obj[i].value = '1';
    		}
    	}
    }
    function delDiv(t){ 
    	// del为删除input的id	
    	$(t).parent().parent().remove();
    }
    function delpara(t){ 
    	$(t).parent().remove();
    }

    
    </script>

</head>
<body>
	<br>
	<br />

	<div id="content">
		<!-- forms -->
		<div class="box">
			<!-- box / title -->
			<div class="title">
				<h5>商品信息修改</h5>
			</div>
			<!-- end box / title -->
			<form:form method="post" id="fm" commandName="sale" htmlEscape="true"
				acceptCharset="utf-8" cssClass="required-validate" enctype="multipart/form-data" onsubmit="sub()">
				 <form:hidden path="groupFlag" value="0"/>
				 <input type="hidden" id="backUrl" name="backUrl" />
				<div class="form">
					<div class="fields">
					<h3>1.基本信息</h3>	
						<div class="field">
							<div class="label">
								<label for="shopId" class="req">所属商户：</label>
							</div>
							<div class="input">
								${store.name}
								<form:hidden path="storeId" maxlength="100" />
							</div>
						</div>
						<div class="field" id="typeIdDiv">
							<div class="label">
								<label for="typeId" class="req">商品分类：</label>
							</div>
							<div class="input">
								<form:hidden path="typeId" cssClass="small required"
									maxlength="100" />
								<form:input path="typeName" maxlength="100" readonly="true" value="${typeName }"
									cssClass="small required" />
								<span class="error" id="advice-required-typeName"
									style="display:none"></span>
							</div>
						</div>
					<div class="field" >
							<div class="label">
								<label for="select">是否营销商品:</label>
							</div>
							<div class="select">
								<select id="select" name="iseckill"    onchange="iseckchange(this.value)" >
									<c:forEach items="${iseckillMap}" var="eckill">
										<option value="${eckill.key }" <c:if test="${sale.iseckill eq eckill.key }">selected="selected" </c:if>>${eckill.value }</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
							<div id="iseckillPrice1" class="field"  style="display: none;">
							<div class="label">
								<label for="iseckillPrice" class="req">秒杀价:</label>
							</div>
							<div class="input">
								<form:input path="iseckillPrice" value="${sale.iseckillPrice}" cssClass="required validate-pattern-/^\d+(\.\d+)?$/ float-range--0-9999999.99"
									maxlength="10" /> 元
								<span class="error"  id="advice-validate-pattern-iseckillPrice" 
									style="display:none" ></span>
								<span class="error" id="advice-required-iseckillPrice"
									style="display:none"></span>
							</div>
						</div>
						
					<div class="field" style="display: none">
						<div class="label">
							<label for="goodTypeName" >货架分类：</label>
						</div>
						<div class="input">
						    <form:hidden path="goodTypeId" cssClass="small required" maxlength="100"/>
							<form:input path="goodTypeName" maxlength="100" readonly="true" cssClass="small" />
							<span class="error" id="advice-required-goodTypeName" style="display:none"></span>
						</div>
				    </div>
						<%--<div class="field">
							<div class="label label-radio">
								<label for="itemMode">商品类型：</label>
							</div>
							<div class="radios">
								<div class="radio">
									<c:forEach items="${itemModeMap}" var="item" varStatus="index">
										<input type="radio" id="radio-${index.count }" name="itemMode"
											class="validate-one-required"
											<c:if test="${item.key==sale.itemMode }">checked="checked"</c:if>
											value="${item.key}" />
										<label for="radio-${index.count }">${item.value }</label>
									</c:forEach>
								</div>
								<span class="error" id="advice-validate-one-required-itemMode"
									style="display:none"></span>
							</div>
						</div>
						
						 --%><!--  =============虚拟产品类型隐藏 =======
						<div class="field" id="virtualTypeView"
							<c:if test="${sale.itemMode == 0 }" >style="display: none"</c:if>>
							<div class="label label-radio">
								<label for="virtualType" class="req">虚拟产品类型：</label>
							</div>
							<div class="radios">
								<div class="radio">
									<c:forEach items="${virtualTypeMap}" var="item"
										varStatus="index">
										<input type="radio" id="radio-1${index.count }"
											name="virtualType" class="validate-one-required"
											<c:if test="${item.key==sale.virtualType }">checked="checked"</c:if>
											value="${item.key}" />
										<label for="radio-1${index.count }">${item.value }</label>
									</c:forEach>
								</div>
								<span class="error" id="advice-validate-one-required-itemMode"
									style="display:none"></span>
								<span class="error" id="advice-validate-one-required-virtualType" style="display:none"></span>
							</div>
						</div>
 						=============虚拟产品类型隐藏 ======= -->
						<div class="field">
							<div class="label">
								<label for="name" class="req">商品名称：</label>
							</div>
							<div class="input">
								<!-- small medium large -->
								<form:input path="name" maxlength="100"
									cssClass="small required" />
								<span class="error" id="advice-required-name"
									style="display:none"></span>
							</div>
						</div>

						<div class="field">
							<div class="label">
								<label for="shortName" class="req">商品简称：</label>
							</div>
							<div class="input">
								<!-- small medium large -->
								<form:input path="shortName" maxlength="50" cssClass="small required" />
								<span class="error" id="advice-required-shortName"
									style="display:none"></span>
							</div>
						</div>

						<div class="field">
							<div class="label">
								<label for="brand" class="req">品牌：</label>
							</div>
							<div class="input">
								<!-- small medium large -->
								<form:input path="brand"   cssClass="small required " /><!-- <a href="javascript:void(0);" id="

Brand">选择</a>  -->
								<span class="error" id="advice-required-brand" style="display:none"></span>
							</div>
						</div>
						<div class="field">
							<div class="label label-textarea">
								<label for="tag">标签（用";"隔开）：</label>
							</div>
							<div class="input">
								<form:input path="tag" maxlength="100" cssClass="small" />
								<span class="error" id="advice-required-tag" style="display:none"></span>
							</div>
						</div>
						<div class="field">
							<div class="label">
								<label for="marketContent">营销语：</label>
							</div>
							<div class="input">
								<form:input path="marketContent" maxlength="10" size="100" />
								<span class="error" id="advice-required-marketContent"
									style="display:none"></span>
							</div>
						</div>

						<div class="field">
							<div class="label">
								<label for="warmPrompt">温馨提示：</label>
							</div>
							<div class="input">
								<form:input path="warmPrompt" maxlength="40" size="100" />
								<span class="error" id="advice-required-warmPrompt"
									style="display:none"></span>
							</div>
						</div>
						<div class="field">
							<div class="label label-textarea">
								<label for="remark">商品介绍：</label>
							</div>
							<div class="input">
								<ht:xheditor />
								<form:textarea path="remark" cols="50" rows="8"
									cssClass="cxheditor max-length-300" />
							</div>
						</div>

					</div>
				</div>
				
				<div class="form">
        <div class="fields">
        	<div id="parameterId" >
        	 <!-- 加载商品参数 -->
             </div> 
        	 <div class="field">
                    <div class="label">
                        <label for="name">自定义参数</label>
                    </div>
                    <div class="input">
                    		<a href="javascript:void(0);" id="addpara">增加一个参数</a> &nbsp;
                    </div>
            </div>
        	 <div class="field">
             	<div class="label">
                        <label for="name">&nbsp;</label>
                </div>
                <div class="input">
	            	<div class="dl" id="divAddpara">
	            	<c:forEach items="${paralist }" var="item">
	            	<div class='dl'><br />
	            	<span style="float:left">参数名称：</span><input type='text' name='customparakey' value=${item.paramKey } maxlength='10'/>
	            	<span style="float:left">参数值:</span><input type='text' name='customparavalue' value=${item.paramValue } maxlength='10'/>
	            	<a href='javascript:void(0);' id='del' onclick='delpara(this)' title='删除'><font color='red'>删除</font></a>
	            	</div>
	            	
	           		</c:forEach>
	                </div>
                </div>
            </div>
            <!--
        	<div class="field">
                    <div class="label">
                        <label for="name">商品属性</label>
                    </div>
                    <div class="input">
                    		 <a href="javascript:void(0);" id="add">增加一个属性</a> &nbsp;
                    </div>
            </div>
            
            <div class="field">
                    <div class="label">
                        <label for="name">&nbsp;</label>
                    </div>
                    <div class="input">
                
                <c:forEach items="${itemProperty}" var="itemP" varStatus="index">
                   <div class="dl" id="fath" >
                    <div class="dt class="req">${itemP.propertyName}：</div>
                    <div class="dd">
                        ${itemP.content}
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                         <a href="javascript:void(0);" id="${itemP.id }" class="item_del" title="删除" ><font color="red">删除</font></a>
                        <div>
                        <c:if test="${! empty itemP.imgPath}">
                        <ht:image id="${itemP.itemId}" type="property" webpath="${itemP.imgPath}"/>
                        </c:if>
                        </div>
                    </div>
                    
                </div>
                </c:forEach>
                <div class="dl" id="divAdd">
	            </div>
               </div>
            </div>
             -->
            </div>
        </div>
				
				<div class="form">
					<div class="fields">
						<h3>2.销售信息</h3>	
						<!-- ============不显示 发码方式======== start...-->
						<input type="hidden" id="sendCodeMode" name="sendCodeMode" value="${sale.sendCodeMode}">
						<!-- 
						<div class="field">
							<div class="label label-radio">
								<label>发码方式:</label>
							</div>
							<div class="radios">
								<div class="radio">
									<input type="radio" id="radio-3" name="sendCodeMode" value="0"  <c:if test="${sale.sendCodeMode eq 0 }">checked="checked"</c:if>  /><label for="radio-3">不发码</label> 
									<input type="radio" id="radio-4" name="sendCodeMode" value="1" <c:if test="${sale.sendCodeMode eq 1 }">checked="checked"</c:if>/><label for="radio-4">按照订单发码</label> 
									<input type="radio" id="radio-5" name="sendCodeMode" value="2" <c:if test="${sale.sendCodeMode eq 2 }">checked="checked"</c:if>/> <label for="radio-5">按照商品个数发码</label>
								</div>
								<span class="error" id="advice-validate-one-required-radioex1"
									style="display:none"></span>
							</div>
						</div>
						 -->
						 <!-- ============不显示 发码方式======== ...end-->
						
						<!-- 需要发码此div显示begin -->
					<div id="selSendCode" <c:if test="${sale.sendCodeMode == null || sale.sendCodeMode eq 0 }">style="display: none;"</c:if> >
					
						<!-- ======== 发码类型默认为“二维码”  ======start=== -->
						<%--<input type="hidden" name="verifyCodeType" value="2">--%>
						<!-- 
						<div class="field">
							<div class="label label-radio">
								<label>发码类型设置:</label>
							</div>
							<div class="radios">
								<div class="radio">
									<input type="radio" id="radio-1" name="verifyCodeType" value="1"  class="validate-one-required" <c:if test="${sale.verifyCodeType eq 1 }">checked="checked"</c:if> /><label for="radio-1">一维码</label>
									<input type="radio" id="radio-2" name="verifyCodeType" value="2"  class="validate-one-required" <c:if test="${sale.verifyCodeType eq 2 }">checked="checked"</c:if>  /><label for="radio-2">二维码</label>
								</div>
								<span class="error" id="advice-validate-one-required-verifyCodeType"
									style="display:none"></span>
							</div>
						</div>
						-->
						<!-- ======== 发码类型默认为“二维码”  ======end=== -->
						
						<!-- ======== 发码方默认为“方正码平台” ======start====== -->
						<%--<input type="hidden" name="sendCodeChannel" value="1">--%>
						<!-- 
						<div class="field">
							<div class="label label-radio">
								<label>发码方设置:</label>
							</div>
							<div class="radios">
								<div class="radio">
									<input type="radio" id="radio-6" class="validate-one-required" name="sendCodeChannel" value="0" <c:if test="${sale.sendCodeChannel eq 0 }">checked="checked"</c:if> /><label for="radio-6">平台自己</label>
									<input type="radio" id="radio-7" class="validate-one-required" name="sendCodeChannel" value="1" <c:if test="${sale.sendCodeChannel eq 1 }">checked="checked"</c:if>/><label for="radio-7">方正码平台</label> 
									<input type="radio" id="radio-8"class="validate-one-required"  name="sendCodeChannel" value="2" <c:if test="${sale.sendCodeChannel eq 2 }">checked="checked"</c:if>/> <label for="radio-8">第三方应用</label>
								</div>
								<span class="error" id="advice-validate-one-required-sendCodeChannel"
									style="display:none"></span>
							</div>
						</div>
						 -->
						<!-- 选择第三方应用此div显示begin -->
						<!-- 
						<div class="field" id="sendCodeSrcId" <c:if test="${sale.sendCodeChannel ne 2 }">style="display: none;"</c:if> >
							<div class="label">
								<label for="select">选择制码渠道:</label>
							</div>
							<div class="select">
								<select id="select" name="sendCodeSrc" class="validate-selection">
									<option value="">请选择</option>
									<option value="10" <c:if test="${sale.sendCodeSrc eq 10 }"> selected="selected" </c:if>>85度C</option>
									<option value="11" <c:if test="${sale.sendCodeSrc eq 11 }"> selected="selected" </c:if>>鲜芋仙</option>
								</select>
							</div>
						</div>
						 -->
						<!-- 选择第三方应用此div显示 end-->
						<!-- ======== 发码方默认为“房子码平台” ======end====== -->
						
						<!-- =======验证时间和验证天数，二选一 start====== -->
						<div class="field">
							<div class="label">
								 <label for="verifyStartTime" class="req">验证码有效期:</label>
							</div>
							 <div class="radios">
								<div class="radio">
									<input type="radio" id="radio-vt" name="radio-verify" class="validate-one-required" value="0" <c:if test="${sale.verifyStartTime != null}">checked</c:if> /><label for="radio-vt">按时间验证</label>
									<input type="radio" id="radio-vd" name="radio-verify" class="validate-one-required" value="1" <c:if test="${sale.verifyDay != null}">checked</c:if> /><label for="radio-vd">按天数验证 </label> 
								</div>
								<span class="error" id="advice-validate-one-required-sendCodeChannel"
									style="display:none"></span>
								<span class="error" id="advice-validate-one-required-radio-verify"></span>
							</div>
						</div>
					
						<c:if test="${sale.verifyStartTime eq null}">
						<div id="verifyTime" style="display:none">
						</c:if>
						<c:if test="${sale.verifyStartTime != null}">
						<div id="verifyTime" >
						</c:if>
							<div class="field">
								<div class="label">
									<label for="verifyStartTime" class="req">验证开始时间:</label>
								</div>
								<div class="input">
									<input type="text" id="verifyStartTime" name="verifyStartTime"
										class="date required" readOnly  value="<ct:time source="${sale.verifyStartTime}" sfmt="yyyyMMddHHmmss" tfmt="yyyy-MM-dd HH:mm:ss"/>"
										onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss' ,maxDate:'#F{$dp.$D(\'verifyStopTime\')||\'2020-10-01\'}'})" />
								</div>
							</div>
							<div class="field">
								<div class="label">
									<label for="verifyStopTime" class="req">验证结束时间:</label>
								</div>
								<div class="input">
									<input type="text" id="verifyStopTime" name="verifyStopTime" class="date required" readOnly  value="<ct:time source="${sale.verifyStopTime}" sfmt="yyyyMMddHHmmss" tfmt="yyyy-MM-dd HH:mm:ss"/>"
										onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'verifyStartTime\')}',maxDate:'2020-10-01'})" />
								</div>
							</div>
						</div>
						
						<c:if test="${sale.verifyDay eq null}">
							<div id="verifyDays" style="display:none">
						</c:if>
						<c:if test="${sale.verifyDay != null}">
							<div id="verifyDays">
						</c:if>
							<div class="field">	
								<div class="label">
									<label for="verifyDay" class="req">验证天数:</label>
								</div>
								<div class="input">
	                				<table border = "0">
	                					<tr><td>购买成功起，</td>
	                					<td> <form:input path="verifyDay" cssClass="small required validate-pattern-/^\d+(\.\d+)?$/" maxlength="5" style="width:50px" /></td>
	                					<td>天有效</td></tr>
	                				</table>
	                				<span class="error" id="advice-required-verifyDay" style="display:none"></span>
								</div>
							</div>
						</div>
						<!-- =======验证时间和验证天数，二选一 start====== -->
						
						<div class="field">
							<div class="label">
								<label for="verifyShopName">验证门店:</label>
							</div>
							<div class="input">
								<form:input path="verifyShopName" cssClass="small"
									maxlength="100" readonly="true" />
								<form:hidden path="verifyShopIds" />
								<span class="error" id="advice-verifyShopName"
									style="display:none"></span>
							</div>
						</div>
						
						</div>
					<!-- 需要发码此div显示end -->

						<!-- 不需要发码此div显示 begin -->
                        <div id="selLogistics" <c:if test="${sale.sendCodeMode ne 0}">style="display: none;"</c:if> >

						<!-- 不发码显示是否需要物流 -->
						<div class="field">
							<div class="label label-radio">
								<label>物流信息:</label>
							</div>
							<div class="radios">
								<div class="radio">
									<input type="radio" id="radio-9" name="postFlag" class="validate-one-required" value="0" <c:if test="${sale.postFlag eq 0}"> checked="checked" </c:if> /><label for="radio-9">用户自取</label> 
									<input type="radio" id="radio-10" name="postFlag" class="validate-one-required"  value="1" <c:if test="${sale.postFlag eq 1}"> checked="checked" </c:if> /><label for="radio-10">物流配送</label>
								</div>
								<span class="error" id="advice-validate-one-required-postFlag"
									style="display:none"></span>
							</div>
						</div>
						
						<!-- 需要物流配送此div显示 begin-->
						<div id="isPost" <c:if test="${sale.postFlag eq 0}">style="display: none;"</c:if>>
						<div class="field"  style ="display: none;">
							<div class="label">
								<label for="postArea" class="req">配送区域选择:</label>
							</div>
							<div class="input">
								<form:input path="postArea" cssClass="small required"
									 readonly="true"/><form:hidden path="postAreaCode"/>
									
								<span class="error" id="advice-required-postArea"
									style="display:none"></span>
							</div>
						</div>
						<div class="field">	
							<div class="label">
								<label for="logisticsFee" class="req">物流运费:</label>
							</div>
							<div class="input">
								 <form:input path="logisticsFee" cssClass=" required validate-pattern-/^\d+(\.\d+)?$/ float-range--0-9999999.99" maxlength="10"/>
                				 <input type="checkbox" id="logisticsFeeType" name="logisticsFeeType" value="1"   <c:if test="${sale.logisticsFeeType eq 1}">checked="checked"</c:if>/>累计计算
								 <span class="error" id="advice-required-logisticsFee" style="display:none"></span>
								 <span class="error" id="advice-validate-pattern-logisticsFee" 
									style="display:none" ></span>
							</div>
							
						</div>
						
						
						</div>
						<!-- 需要物流配送此div显示 end -->
						</div>
						<!-- 不需要发码此div显示  end-->
						
						
						
						<div class="field">
							<div class="label">
								<label for="saleStartTime" class="req">销售开始时间：</label>
							</div>
							<div class="input">
								<input type="text" id="saleStartTime" name="saleStartTime"
									class="date required" readOnly  value="<ct:time source="${sale.saleStartTime}" sfmt="yyyyMMddHHmmss" tfmt="yyyy-MM-dd HH:mm:ss"/>"
									onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss' ,maxDate:'#F{$dp.$D(\'verifyStopTime\')||$dp.$D(\'saleStopTime\')||\'2020-10-01\'}'})" />
							</div>
						</div>
						<div class="field">
							<div class="label">
								<label for="saleStopTime" class="req">销售结束时间：</label>
							</div>
							<div class="input">
								<input type="text" id="saleStopTime" name="saleStopTime" 
									class="date required" readOnly value="<ct:time source="${sale.saleStopTime}" sfmt="yyyyMMddHHmmss" tfmt="yyyy-MM-dd HH:mm:ss"/>"
									onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'saleStartTime\', {H:1});}',maxDate:'2020-10-01'})" />
							</div>
						</div>
						
						
						
						<div class="field">
							<div class="label">
								<label for="saleAreaName" class="req">显示区域:</label>
							</div>
							<div class="input">
								<form:input path="saleAreaName" cssClass="small required"
									style="width:600px" readonly="true" />
								<form:hidden path="saleAreaCode" />
								 
								<span class="error" id="advice-required-saleAreaName"
									style="display:none"></span>
							</div>
						</div>
						
						
						
					<div id="div_saleShopName" style="display: none;">
						<div class="field">
							<div class="label">
								<label for="saleShopName" >销售门店:</label>
							</div>
							<div class="input">
								<form:input path="saleShopName" cssClass="small"
									maxlength="100" readonly="true" />
								<form:hidden path="saleShopIds" />
							</div>
						</div>
					</div>	
						<!-- 
				<div class="field">
                    <div class="label label-checkbox">
                        <label>购买用户限制:</label>
                    </div>
                    <div class="checkboxes">
                        <div class="checkbox">
                            <input type="checkbox" id="checkbox-1" name="buyLimit" value="0"<c:if test="${fn:contains(sale.buyLimit,'0')}"> checked="checked" </c:if>/><label for="checkbox-1">会员级别限制</label> 
							<input type="checkbox" id="checkbox-2" name="buyLimit" value="1"<c:if test="${fn:contains(sale.buyLimit,'1')}"> checked="checked" </c:if>/><label for="checkbox-2">购买用户地市限制</label>
							<input type="checkbox" id="checkbox-3" name="buyLimit" value="2" <c:if test="${fn:contains(sale.buyLimit,'2')}"> checked="checked" </c:if>/><label for="checkbox-3">单个用户购买数量</label>
                        </div>
                        <span class="error" id="advice-validate-one-required-buyLimit" style="display:none"></span>
                    </div>
                </div>
				 -->		
				 
				 
				 	<div class="field" >
							<div class="label">
								<label for="marketPrice" class="req">市场价(元):</label>
							</div>
							<div class="input">
								<form:input path="marketPrice" cssClass=" required validate-pattern-/^\d+(\.\d+)?$/ float-range--0-9999999.99"
									maxlength="10" />
								<span class="error"  id="advice-validate-pattern-marketPrice" 
									style="display:none" ></span>
								<span class="error" id="advice-required-marketPrice"
									style="display:none"></span>
							</div>
						</div>
						
						<div class="field" >
							<div class="label">
								<label for="marketPrice" class="req">商城价(元):</label>
							</div>
							<div class="input">
								<form:input path="shopPrice" cssClass="required validate-pattern-/^\d+(\.\d+)?$/ float-range--0-9999999.99"
									maxlength="10" />
								<span class="error"  id="advice-validate-pattern-shopPrice" 
									style="display:none" ></span>
								<span class="error" id="advice-required-shopPrice"
									style="display:none"></span>
								
							</div>
						</div>
				 
				<div class="field" id="areaLimit">
							<div class="label">
								<label for="areaLimitName" >购买用户地市限制:</label>
							</div>
							<div class="input">
								<form:input path="areaLimitName" 
									maxlength="100" readonly="true" />
								<form:hidden path="areaLimitCode" />
								<span class="error" id="advice-required-areaLimitName"
									style="display:none"></span>
							</div>
						</div>
						
				<div class="field" id="userLimit">
                    <div class="label label-checkbox">
                        <label>会员级别限制:</label>
                    </div>
                    <div class="checkboxes">
                        <div class="checkbox">
                        	<c:forEach items="${pricetypeList }" var="item" varStatus="status">
                        		<input type="checkbox" id="checkbox-${status.index + 4 }" name="userLimitCode" value="${item.priceTypeCode }" onclick="clickUserLimit(this.value)" <c:if test="${fn:contains(sale.userLimitCode,item.priceTypeCode)}">checked="checked"</c:if>/>
                        		<label for="checkbox-${status.index + 4 }">${item.priceType }</label> 
							</c:forEach>
                        </div>
                    </div>
                </div>
						
						
					
						
									<div class="field" >
							<div class="label">
								<label for="priceId" >支付价格配置:</label>
							</div>
						<div class="input" id="priceId">
								 <table border='0' style='width:500px'   id="TbData" name="TbData"  cellpadding="0" cellspacing="0" >
								  <c:forEach items="${priceList}" var="item">
								     <tr>
								     <td align='left' style='width:80px'>
								       <c:choose>
									       <c:when test="${empty  item.priceType }">
									         ${map[item.priceTypeCode] }:
									       </c:when>
									       <c:otherwise>
									          ${item.priceType }价:
									       </c:otherwise>
								       </c:choose>
								     </td>
								      <td>
								       <input  name='priceTypeCode'  type='hidden' value='${item.priceTypeCode }' />
								       <input  name='price' id='${item.priceTypeCode }'  type='text' value='${item.price }' maxlength='50' onblur='blurUserLimit(this.id);' />元
										&nbsp;&nbsp;&nbsp;&nbsp;<span id='vali${item.priceTypeCode }' style='color:red;' ></span>
									  </td>
									</tr>
								 </c:forEach>
							  </table>&nbsp;
							</div>
						
						</div>
						
						<div class="field" id="numLimit">
							<div class="label">
								<label for="userPerBuyNum" >单个用户购买数量:</label>
							</div>
							<div class="input">
								<form:input path="userPerBuyNum" cssClass="validate-pattern-/^\d+(\.\d+)?$/"
									maxlength="8"  />
									&nbsp;&nbsp;&nbsp;
									<span style="color: red;">0表示不限购</span>
								<span class="error" id="advice-required-userPerBuyNum"
									style="display:none"></span>
							</div>
						</div>
						
						<div class="field" >
							<div class="label">
								<label for="stockNum" class="req">商品库存:</label>
							</div>
							<div class="input">
								<input  name='stockNum'  id="stockNum" class=' required validate-pattern-/^\d+(\.\d+)?$/' type='text' value='${sale.stockNum }' maxlength='50' <c:if test="${storeNum eq initStoreNum}"> readonly="true" </c:if>/>
                <input type="checkbox" id="unlimitedStockNum" name="unlimitedStockNum" value="0"  <c:if test="${storeNum eq initStoreNum}">checked="checked" </c:if> >不限
								<span class="error" id="advice-required-stockNum"
									style="display:none"></span>
								<span class="error" id="advice-validate-pattern-stockNum"
									style="display:none"></span>
							</div>
						</div>
					
<!-- 
						<div class="field">
							<div class="label label-radio">
								<label>选择费率:</label>
							</div>

							<div class="select">
								<select name="feeType">
									<c:forEach items="${feeList }" var="item">
										<option <c:if test="${item.id==sale.feeType }">selected</c:if>
											value="${item.id }">${item.name }</option>
									</c:forEach>

								</select>
							</div>
						</div>
						 -->
						<div class="buttons">
							<div class="highlight">
								<input id="submitButton" type="submit" name="submit.highlight" value="提交" />
							</div>
							<input type="reset" name="reset" value="重置" /> <input
								type="button" class="common_btn" onclick="history.back();"
								value="返回" />
						</div>
					</div>
				</div>
				
				
		</div>
		</form:form>
	</div>
	<!-- end forms -->

</body>
</html>