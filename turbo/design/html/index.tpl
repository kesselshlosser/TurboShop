<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
	<META HTTP-EQUIV="Expires" CONTENT="-1"/>
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
	<title>{$meta_title|escape}</title>
	<link rel="icon" href="design/images/favicon.png" type="image/x-icon" />
	<script src="design/js/jquery/jquery.js"></script>
	<script src="design/js/jquery/jquery-ui.min.js"></script>
	<link rel="stylesheet" type="text/css" href="design/js/jquery/jquery-ui.min.css" />
	<link href="design/css/turbo.css" rel="stylesheet" type="text/css" />
	<link href="design/css/simple-line-icons.min.css" rel="stylesheet" type="text/css" />
	<link href="design/css/media.css" rel="stylesheet" type="text/css" />
	<script src="design/js/jquery.scrollbar.min.js"></script>
	<script src="design/js/bootstrap.min.js"></script>
	<script src="design/js/bootstrap-select.js"></script>
	<script src="design/js/jquery.dd.min.js"></script>
	{if $smarty.get.module == "OrdersAdmin"}
	<script src="design/js/jquery/datepicker/jquery.ui.datepicker-{$settings->lang}.js"></script>
	{/if}
	<script src="design/js/toastr.min.js"></script>
	<script src="design/js/Sortable.js"></script>
</head> 
<body class="navbar-fixed {if $smarty.cookies.view !== 'fixed' && $is_mobile === false && $is_tablet === false}menu-pin{/if}">  
	<a href="index.php?module=ProductsAdmin" id="fix_logo" class="hidden-lg-down"></a> 
	<nav id="admin_catalog" class="fn_left_menu">
		<div id="mob_menu"></div>
		<div class="sidebar_header">
			<a class="logo_box" href="index.php?module=ProductsAdmin" class="">
				<img src="design/images/logo_title.png" alt="TurboCMS"/>
			</a>
			{if $is_mobile === false && $is_tablet === false}
			{if $smarty.cookies.view != 'fixed'}
			<span onclick="document.cookie='view=fixed;path=/';document.location.reload();" href="javascript:;" class="fn_switch_menu menu_switch hint-left-middle-t-white-s-small-mobile  hint-anim" data-hint="{$btr->catalog_hide|escape}">
				<span class="menu_hamburger"></span>
			</span>
			{else}
			<span onclick="document.cookie='view=/;path=/';document.location.reload();" href="javascript:;" class="fn_switch_menu menu_switch hint-left-middle-t-white-s-small-mobile  hint-anim" data-hint="{$btr->catalog_fixation|escape}">
				<span class="menu_hamburger"></span>
			</span>
			{/if}
			{else}
			<span class="fn_switch_menu menu_switch" data-module="managers" data-action="menu_status" data-id="{$manager->id}">
				<span class="menu_hamburger"></span>
			</span>
			{/if}
		</div>
		<div class="sidebar sidebar-menu">
			<div class="scrollbar-inner menu_items">
				<div>
					<ul class="menu_items">
						{if in_array('products', $manager->permissions) || in_array('categories', $manager->permissions) || in_array('brands', $manager->permissions) || in_array('features', $manager->permissions)}
						<li class="{if in_array($smarty.get.module, array("ProductsAdmin","ProductAdmin","CategoriesAdmin","CategoryAdmin","BrandsAdmin","BrandAdmin","FeaturesAdmin","FeatureAdmin"))}open active{/if} fn_item_sub_switch nav-dropdown">
							<a class="nav-link fn_item_switch nav-dropdown-toggle" href="javascript:;">
								<span class="left_catalog title">{$btr->general_catalog|escape}</span>
								<span class="icon-thumbnail">
									<svg width="20px" height="20px" viewBox="0 0 16 14" xmlns="http://www.w3.org/2000/svg"><path d="M.81.453h2.804v2.805H.81V.453zm0 5.184h2.804v2.805H.81V5.637zm0 5.184h2.804v2.804H.81v-2.804zM4.86.453h10.33v2.805H4.86V.453zm0 5.184h10.33v2.805H4.86V5.637zm0 5.184h10.33v2.804H4.86v-2.804z" fill="currentColor" fill-rule="evenodd"/></svg>
								</span>
								<span class="arrow"></span>
							</a>
							<ul class="fn_submenu_toggle submenu">
								{if in_array('products', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("ProductsAdmin", "ProductAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=ProductsAdmin">
										<span class="icon-thumbnail">
											<i class="icon-handbag icons font-lg d-block mt-4"></i>                                                  
										</span>
										<span class="left_products_title title">{$btr->general_products|escape}</span>
									</a>
								</li>
								{/if}
								{if in_array('categories', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("CategoriesAdmin","CategoryAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=CategoriesAdmin">
										<span class="icon-thumbnail">
											<i class="icon-grid  icons font-lg d-block mt-4"></i>  
										</span>
										<span class="left_categories_title title">{$btr->general_categories|escape}</span>
									</a>
								</li>
								{/if}
								{if in_array('brands', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("BrandsAdmin","BrandAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=BrandsAdmin">
										<span class="icon-thumbnail">
											<i class="icon-star icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_brands_title title">{$btr->brands_brands|escape}</span>
									</a>
								</li>
								{/if}
								{if in_array('features', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("FeaturesAdmin","FeatureAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=FeaturesAdmin">
										<span class="icon-thumbnail">
											<i class="icon-calculator  icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_features_title title">{$btr->general_features|escape}</span>
									</a>
								</li>
								{/if}
							</ul>
						</li>
						{/if}
						{if in_array('orders', $manager->permissions) || in_array('labels', $manager->permissions)}
						<li class="{if in_array($smarty.get.module, array("OrdersAdmin", "OrderAdmin", "OrdersLabelsAdmin", "OrdersLabelAdmin"))}open active{/if} fn_item_sub_switch nav-dropdown">
							<a class="nav-link fn_item_switch nav-dropdown-toggle" href="javascript:;">
								<span class="left_orders title">{$btr->general_orders}</span>
								<span class="icon-thumbnail">
									<svg width="20px" height="20px" viewBox="0 0 510 510"><g id="shopping-cart"><path d="M153,408c-28.05,0-51,22.95-51,51s22.95,51,51,51s51-22.95,51-51S181.05,408,153,408z M0,0v51h51l91.8,193.8L107.1,306    c-2.55,7.65-5.1,17.85-5.1,25.5c0,28.05,22.95,51,51,51h306v-51H163.2c-2.55,0-5.1-2.55-5.1-5.1v-2.551l22.95-43.35h188.7    c20.4,0,35.7-10.2,43.35-25.5L504.9,89.25c5.1-5.1,5.1-7.65,5.1-12.75c0-15.3-10.2-25.5-25.5-25.5H107.1L84.15,0H0z M408,408    c-28.05,0-51,22.95-51,51s22.95,51,51,51s51-22.95,51-51S436.05,408,408,408z" fill="currentColor"/></g></svg>
								</span>
								<span class="arrow"></span>
								{if $new_orders_counter}<span class="menu_counter orders">{$new_orders_counter}</span>{/if}
							</a>
							<ul class="fn_submenu_toggle submenu">
								{if in_array('orders', $manager->permissions)}
								<li {if $status===0}class="active"{/if} {if in_array($smarty.get.module, array("OrderAdmin"))}{if $order->status==0}class="active"{/if}{/if}>
									<a class="nav-link" href="index.php?module=OrdersAdmin&status=0">
										<span class="icon-thumbnail">
											<i class="icon-basket-loaded icons font-lg d-block mt-4"></i>
											{if $new_orders_counter}<span class="menu_counters orders">{$new_orders_counter}</span>{/if}
										</span>
										<span class="left_orders_title title">{$btr->general_new_order}</span>
									</a>
								</li>
								<li {if $status==1 || $order->status==1}class="active"{/if}>
									<a class="nav-link" href="index.php?module=OrdersAdmin&status=1">
										<span class="icon-thumbnail">
											<i class="icon-plus icons font-lg d-block mt-4"></i>  
										</span>
										<span class="left_orders_settings_title title">{$btr->general_accepted_order|escape}</span>
									</a>
								</li>
								<li {if $status==2 || $order->status==2}class="active"{/if}>
									<a class="nav-link" href="index.php?module=OrdersAdmin&status=2">
										<span class="icon-thumbnail">
											<i class="icon-check icons font-lg d-block mt-4"></i>  
										</span>
										<span class="left_orders_settings_title title">{$btr->general_closed_order|escape}</span>
									</a>
								</li>
								<li {if $status==3 || $order->status==3}class="active"{/if}>
									<a class="nav-link" href="index.php?module=OrdersAdmin&status=3">
										<span class="icon-thumbnail">
											<i class="icon-trash icons font-lg d-block mt-4"></i>  
										</span>
										<span class="left_orders_settings_title title">{$btr->general_canceled_order|escape}</span>
									</a>
								</li>
								{/if}
								{if $keyword}
								<li class="active">
									<a class="nav-link" href="{url module=OrdersAdmin keyword=$keyword id=null label=null}">
										<span class="icon-thumbnail">
											<i class="icon-magnifier icons font-lg d-block mt-4"></i>  
										</span>
										<span class="left_orders_settings_title title">{$btr->general_search_order|escape}</span>
									</a>
								</li>
								{/if}
								{if in_array('labels', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("OrdersLabelsAdmin","OrdersLabelAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=OrdersLabelsAdmin">
										<span class="icon-thumbnail">
											<i class="icon-tag icons font-lg d-block mt-4"></i>  
										</span>
										<span class="left_orders_settings_title title">{$btr->general_labels}</span>
									</a>
								</li>
								{/if}
							</ul>
						</li>
						{/if}
						{if in_array('users', $manager->permissions) || in_array('groups', $manager->permissions) || in_array('coupons', $manager->permissions)}
						<li class="{if in_array($smarty.get.module, array("UsersAdmin","UserAdmin","GroupsAdmin","GroupAdmin","CouponsAdmin","CouponAdmin"))}open active{/if} fn_item_sub_switch nav-dropdown">
							<a class="nav-link fn_item_switch nav-dropdown-toggle" href="javascript:;">
								<span class="left_users title">{$btr->users_users|escape}</span>
								<span class="icon-thumbnail">
									<svg width="20" height="20" viewBox="0 0 24 19" xmlns="http://www.w3.org/2000/svg"><g fill="currentColor" fill-rule="evenodd"><path d="M3.753 13.301c1.21-.803 2.554-1.285 3.852-1.714.187-.061.374-.143.56-.206l.037-.023a5.39 5.39 0 0 0 .748-.31 1.14 1.14 0 0 0 .04-.123C7.922 9.363 7.194 6.949 7.194 4.882c0-1.755.55-3.054 1.59-3.845C8.336.808 7.792.722 7.21.722c-1.556 0-2.816.62-2.816 2.85 0 1.481.556 3.296 1.384 4.35a2.822 2.822 0 0 1-.032.25c-.05.227-.13.481-.342.607-.237.141-.5.231-.76.321-1.076.363-2.191.681-3.146 1.317-.498.328-.834.977-1.019 1.534-.192.58-.27 1.146-.257 1.929h2.935c.186-.392.384-.44.596-.579zM22.398 10.438c-.956-.634-2.071-.964-3.148-1.327a4.062 4.062 0 0 1-.76-.326c-.213-.126-.291-.384-.341-.609a2.949 2.949 0 0 1-.04-.363c.779-1.069 1.298-2.811 1.298-4.241 0-2.23-1.26-2.852-2.816-2.852-.591 0-1.14.092-1.592.325 1.03.792 1.577 2.088 1.577 3.837 0 2.011-.676 4.329-1.703 5.901a1.285 1.285 0 0 0 .073.271c.225.124.494.224.796.329l.45.15c1.333.443 2.71.978 3.951 1.803.203.131.392.152.57.544h2.96c.012-.783-.067-1.348-.258-1.929-.185-.555-.521-1.185-1.017-1.513z"/><path d="M19.626 14.044c-1.275-.846-2.76-1.29-4.193-1.774-.348-.12-.699-.25-1.016-.439-.284-.167-.39-.51-.454-.811a4.095 4.095 0 0 1-.057-.485c1.042-1.424 1.731-3.747 1.731-5.653 0-2.974-1.68-3.803-3.753-3.803-2.073 0-3.753.829-3.753 3.803 0 1.973.741 4.394 1.845 5.8-.01.11-.023.222-.043.333-.066.301-.172.64-.454.809-.317.187-.67.307-1.015.427-1.436.483-2.92.91-4.194 1.756-.664.436-1.113 1.277-1.36 2.022-.255.769-.36 1.76-.344 2.54h18.763c.015-.78-.09-1.771-.344-2.542-.248-.743-.697-1.546-1.359-1.983z"/></g></svg>
								</span>
								<span class="arrow"></span>
							</a>
							<ul class="fn_submenu_toggle submenu">
								{if in_array('users', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("UsersAdmin","UserAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=UsersAdmin">
										<span class="icon-thumbnail">
											<i class="icon-user  icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_users_title title">{$btr->left_users_title|escape}</span>
									</a>
								</li>
								{/if}
								{if in_array('groups', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("GroupsAdmin","GroupAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=GroupsAdmin">
										<span class="icon-thumbnail">
											<i class="icon-people  icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_groups_title title">{$btr->left_groups_title|escape}</span>
									</a>
								</li>
								{/if}
								{if in_array('coupons', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("CouponsAdmin","CouponAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=CouponsAdmin">
										<span class="icon-thumbnail">
											<i class="icon-present   icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_coupons_title title">{$btr->left_coupons_title|escape}</span>
									</a>
								</li>
								{/if}
							</ul>
						</li>
						{/if}
						{if in_array('pages', $manager->permissions) || in_array('menus', $manager->permissions)}
						<li class="{if in_array($smarty.get.module, array("PagesAdmin","PageAdmin","MenuAdmin","indexAdmin"))}open active{/if} fn_item_sub_switch nav-dropdown">
							<a class="nav-link fn_item_switch nav-dropdown-toggle" href="javascript:;">
								<span class="left_users title">{$btr->left_pages|escape}</span>
								<span class="icon-thumbnail">
									<svg width="20" height="20" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><g fill="currentColor" fill-rule="evenodd"><path d="M17.88.496H1.843C.888.496.11 1.231.11 2.136v15.241c0 .905.778 1.641 1.733 1.641H17.88c.956 0 1.734-.736 1.734-1.64V2.134c0-.904-.778-1.639-1.734-1.639zm0 17.334H1.843a.466.466 0 0 1-.477-.453V5.373h16.992v12.004c0 .25-.214.453-.478.453z"/><path d="M11.65 3.529a.65.65 0 0 0 .444-.175.586.586 0 0 0 .184-.42.587.587 0 0 0-.184-.42.653.653 0 0 0-.888 0 .586.586 0 0 0-.184.42c0 .157.068.31.184.42a.65.65 0 0 0 .444.175zM7.487 9.312h4.75c.347 0 .628-.266.628-.594 0-.328-.281-.594-.628-.594h-4.75c-.347 0-.628.266-.628.594 0 .328.281.594.628.594zM15.206 10.792H4.518c-.347 0-.628.266-.628.594 0 .328.281.594.628.594h10.688c.347 0 .628-.266.628-.594 0-.328-.28-.594-.628-.594zM15.206 13.753H4.518c-.347 0-.628.266-.628.594 0 .328.281.594.628.594h10.688c.347 0 .628-.266.628-.594 0-.328-.28-.594-.628-.594z"/></g></svg>
								</span>
								<span class="arrow"></span>
							</a>   
							<ul class="fn_submenu_toggle submenu">
								{if in_array('pages', $manager->permissions)}
								{foreach $menus as $m}
								<li {if $m->id == $menu->id}class="active"{/if}>
									<a class="nav-link" href="index.php?module=PagesAdmin&menu_id={$m->id}">
										<span class="icon-thumbnail">
											<i class="icon-doc icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_pages_title title">{$m->name}</span>
									</a>
								</li>
								{/foreach}
								{/if}
								{if in_array('menus', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("MenuAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=MenuAdmin">
										<span class="icon-thumbnail">
											<i class="icon-menu   icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_managers_title title">{$btr->menus_settings|escape}</span>
									</a>
								</li>
								{/if}
							</ul>
						</li>
						{/if}
						{if in_array('blog', $manager->permissions) || in_array('articles', $manager->permissions)}
						<li class="{if in_array($smarty.get.module, array("BlogAdmin","ArticlesCategoriesAdmin","ArticlesAdmin","ArticleAdmin","PostAdmin","ArticlesCategoryAdmin"))}open active{/if} fn_item_sub_switch nav-dropdown">
							<a class="nav-link fn_item_switch nav-dropdown-toggle" href="javascript:;">
								<span class="left_users title">{$btr->blog_blog|escape}</span>
								<span class="icon-thumbnail">
									<svg width="20" height="20" viewBox="0 0 19 19" xmlns="http://www.w3.org/2000/svg"><defs><path id="a" d="M.01.118v14.683h14.672V.118H.011z"/></defs><g fill="currentColor"><g transform="translate(.435 3.495)"><path d="M0 9.907V14.8h4.894l9.788-9.788L9.788.118 0 9.907zm4.27 3.388H3.013v-1.506H1.506V10.53l1.07-1.07 2.765 2.764-1.07 1.07zm5.895-11.176c.172 0 .258.086.258.259a.272.272 0 0 1-.082.2L3.965 8.954a.274.274 0 0 1-.2.082c-.173 0-.26-.087-.26-.259 0-.078.028-.145.083-.2l6.377-6.376a.272.272 0 0 1 .2-.082z" fill="currentColor"/></g><path d="M17.823 3.671L15.058.92a1.46 1.46 0 0 0-1.07-.447 1.4 1.4 0 0 0-1.06.447l-1.952 1.94 4.895 4.895L17.824 5.8c.29-.29.435-.643.435-1.059 0-.407-.146-.765-.436-1.07z" fill="currentColor"/></g></svg>
								</span>
								<span class="arrow"></span>
							</a>  
							<ul class="fn_submenu_toggle submenu">
								{if in_array('blog', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("BlogAdmin","PostAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=BlogAdmin">
										<span class="icon-thumbnail">
											<i class="icon-book-open  icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_book-open title">{$btr->blog_posts|escape}</span>
									</a>
								</li>
								{/if}
								{if in_array('articles', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("ArticlesCategoriesAdmin","ArticlesCategoryAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=ArticlesCategoriesAdmin">
										<span class="icon-thumbnail">
											<i class="icon-list  icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_book-open title">{$btr->article_categories|escape}</span>
									</a>
								</li>
								<li {if in_array($smarty.get.module, array("ArticlesAdmin","ArticleAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=ArticlesAdmin">
										<span class="icon-thumbnail">
											<i class="icon-pencil  icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_book-open title">{$btr->left_articles_title|escape}</span>
									</a>
								</li>
								{/if}
							</ul>
						</li>
						{/if}
						{if in_array('comments', $manager->permissions) || in_array('feedbacks', $manager->permissions) || in_array('callbacks', $manager->permissions) || in_array('subscribes', $manager->permissions)}
						<li class="{if in_array($smarty.get.module, array("CommentsAdmin","CommentAdmin","FeedbacksAdmin","SubscribesAdmin","CallbacksAdmin"))}open active{/if} fn_item_sub_switch nav-dropdown">
							<a class="nav-link fn_item_switch nav-dropdown-toggle" href="javascript:;">
								<span class="left_comments title">{$btr->general_feedback|escape}</span>
								<span class="icon-thumbnail">
									<svg width="20" height="20" viewBox="0 0 23 19" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g fill="none"><g><path d="M13.23 11.997c1.356-.572 2.425-1.35 3.21-2.334.783-.983 1.175-2.056 1.175-3.215 0-1.159-.392-2.23-1.176-3.215C15.655 2.25 14.586 1.471 13.23.9 11.875.328 10.401.043 8.808.043 7.215.043 5.74.328 4.385.9 3.03 1.47 1.96 2.25 1.176 3.233.392 4.218 0 5.29 0 6.448c0 .993.296 1.927.889 2.803.592.876 1.405 1.614 2.44 2.214-.085.201-.17.384-.257.551a3.167 3.167 0 0 1-.314.482c-.12.154-.214.275-.28.362-.067.088-.176.211-.326.37-.15.158-.246.262-.288.312 0-.008-.017.01-.05.056s-.052.067-.057.063c-.003-.004-.02.017-.05.062l-.043.07-.032.062a.278.278 0 0 0-.024.075.535.535 0 0 0-.006.08c0 .03.003.057.012.082a.418.418 0 0 0 .143.263c.08.067.166.1.257.1h.038c.417-.059.775-.126 1.075-.2a10.511 10.511 0 0 0 3.479-1.602c.75.133 1.484.2 2.202.2 1.592 0 3.067-.285 4.422-.856zm-7-1.045l-.55.388c-.233.158-.492.322-.776.488l.438-1.051-1.214-.7c-.8-.468-1.421-1.018-1.864-1.651-.441-.635-.662-1.294-.662-1.978 0-.85.327-1.647.982-2.39.654-.742 1.536-1.33 2.646-1.764 1.109-.433 2.302-.65 3.578-.65 1.276 0 2.468.217 3.578.65 1.109.435 1.991 1.022 2.646 1.765.655.742.982 1.538.982 2.39 0 .85-.327 1.647-.982 2.389-.655.742-1.537 1.33-2.646 1.764-1.11.434-2.302.65-3.578.65a10.87 10.87 0 0 1-1.914-.175l-.663-.125z" fill="currentColor"/></g><path d="M22.121 13.118c.593-.872.888-1.808.888-2.809 0-1.025-.312-1.985-.938-2.877-.625-.893-1.476-1.635-2.552-2.227a6.418 6.418 0 0 1-.55 5.08c-.559 1-1.36 1.884-2.403 2.652-.967.7-2.068 1.238-3.303 1.614a13.228 13.228 0 0 1-3.866.562c-.25 0-.617-.016-1.1-.05 1.676 1.102 3.645 1.652 5.905 1.652.718 0 1.451-.067 2.202-.2a10.518 10.518 0 0 0 3.478 1.601c.3.075.659.142 1.076.2.1.009.192-.02.275-.087a.462.462 0 0 0 .163-.275c-.004-.05 0-.078.012-.081.012-.004.01-.032-.006-.081l-.025-.076-.03-.062a.591.591 0 0 0-.045-.069.55.55 0 0 0-.05-.063 1.38 1.38 0 0 1-.056-.062 8.891 8.891 0 0 0-.337-.369 4.982 4.982 0 0 1-.326-.369l-.281-.363a3.17 3.17 0 0 1-.313-.482 6.657 6.657 0 0 1-.257-.55c1.034-.6 1.847-1.337 2.44-2.209z" fill="currentColor"/></g></svg>
								</span>
								<span class="arrow"></span>
								{if $all_counter}<span class="menu_counter notification">{$all_counter}</span>{/if}
							</a>
							<ul class="fn_submenu_toggle submenu">
								{if in_array('comments', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("CommentsAdmin","CommentAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=CommentsAdmin">
										<span class="icon-thumbnail">
											<i class="icon-bubbles  icons font-lg d-block mt-4"></i>  
											{if $new_comments_counter > 0}<span class="menu_counters comments">{$new_comments_counter}</span>{/if}
										</span>
										<span class="left_comments_title title">{$btr->general_comments|escape}</span>
									</a>
								</li>
								{/if}
								{if in_array('feedbacks', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("FeedbacksAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=FeedbacksAdmin">
										<span class="icon-thumbnail">
											<i class="icon-speech icons font-lg d-block mt-4"></i> 
											{if $new_feedbacks_counter > 0}<span class="menu_counters feedback">{$new_feedbacks_counter}</span>{/if}
										</span>
										<span class="left_feedbacks_title title">{$btr->general_feedback|escape}</span>
									</a>
								</li>
								{/if}
								{if in_array('callbacks', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("CallbacksAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=CallbacksAdmin">
										<span class="icon-thumbnail">
											<i class="icon-call-out  icons font-lg d-block mt-4"></i> 
											{if $new_callbacks_counter > 0}<span class="menu_counters callbacks">{$new_callbacks_counter}</span>{/if}
										</span>
										<span class="left_callbacks_title title">{$btr->callbacks_requests|escape}</span>
									</a>
								</li>
								{/if}
								{if in_array('subscribes', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("SubscribesAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=SubscribesAdmin">
										<span class="icon-thumbnail">
											<i class="icon-envelope icons font-lg d-block mt-4"></i> 
											{if $new_subscribes_counter > 0}<span class="menu_counters subscribes">{$new_subscribes_counter}</span>{/if}
										</span>
										<span class="left_callbacks_title title">{$btr->subscribe_mailing_subscribes|escape}</span>
									</a>
								</li>
								{/if}
							</ul>
						</li>
						{/if}
						{if in_array('import', $manager->permissions) || in_array('export', $manager->permissions) || in_array('backup', $manager->permissions)}
						<li class="{if in_array($smarty.get.module, array("ImportAdmin","ImportYmlAdmin","ExportAdmin","BackupAdmin","ClearAdmin"))}open active{/if}   fn_item_sub_switch nav-dropdown">
							<a class="nav-link fn_item_switch nav-dropdown-toggle" href="javascript:;">
								<span class="left_auto title">{$btr->general_automation|escape}</span>
								<span class="icon-thumbnail">
									<svg width="20" height="20" viewBox="0 0 23 20" xmlns="http://www.w3.org/2000/svg"><g fill="currentColor" fill-rule="evenodd"><path d="M7.436 2.26v13.689l3.89-3.89 1.159 1.16-5.883 5.884L.719 13.22l1.16-1.16 3.888 3.889V2.259zM15.937 16.937V3.247l-3.889 3.89-1.16-1.16L16.773.094l5.883 5.883-1.16 1.16-3.889-3.89v13.69z"/></g></svg>
								</span>
								<span class="arrow"></span>
							</a>
							<ul class="fn_submenu_toggle submenu">
								{if in_array('import', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("ImportAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=ImportAdmin">
										<span class="icon-thumbnail">
											<i class="icon-arrow-down-circle icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_import_title title">{$btr->left_import_title|escape}</span>
									</a>
								</li>
								{/if}
								{if in_array('import', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("ImportYmlAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=ImportYmlAdmin">
										<span class="icon-thumbnail">
											<i class="icon-action-undo icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_import_title title">{$btr->yml_import_global|escape}</span>
									</a>
								</li>
								{/if}
								{if in_array('export', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("ExportAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=ExportAdmin">
										<span class="icon-thumbnail">
											<i class="icon-arrow-up-circle icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_export_title title">{$btr->left_export_title|escape}</span>
									</a>
								</li>
								{/if}
								{if in_array('backup', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("BackupAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=BackupAdmin">
										<span class="icon-thumbnail">
											<i class="icon-reload  icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_multiimport_title title">{$btr->general_backup|escape}</span>
									</a>
								</li>
								{/if}
								{if in_array('backup', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("ClearAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=ClearAdmin">
										<span class="icon-thumbnail">
											<i class="icon-trash icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_multiimport_title title">{$btr->left_clear_title|escape}</span>
									</a>
								</li>
								{/if}
							</ul>
						</li>
						{/if}
						{if in_array('stats', $manager->permissions)}
						<li class="{if in_array($smarty.get.module, array("StatsAdmin","ReportStatsAdmin","CategoryStatsAdmin"))}open active{/if}  fn_item_sub_switch nav-dropdown">
							<a class="nav-link fn_item_switch nav-dropdown-toggle" href="javascript:;">
								<span class="left_pages title">{$btr->left_stats|escape}</span>
								<span class="icon-thumbnail">
									<svg width="20" height="20" viewBox="0 0 21 20" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><defs><path id="a" d="M.005 0v2.045h20.04V0H.005z"/></defs><g fill="none" fill-rule="evenodd"><g transform="translate(.595 17.066)"><path d="M19.022 0h-18a1.023 1.023 0 1 0 0 2.045h18a1.023 1.023 0 0 0 0-2.045z" fill="currentColor"/></g><path d="M2.674 15.566H5.88c.358 0 .648-.29.648-.647V6.055a.648.648 0 0 0-.648-.647H2.674a.648.648 0 0 0-.647.647v8.864c0 .357.29.647.647.647zM9.015 15.566h3.205c.358 0 .647-.29.647-.647V1.624a.648.648 0 0 0-.647-.648H9.015a.648.648 0 0 0-.647.648v13.295c0 .357.29.647.647.647zM15.356 15.566h3.205c.357 0 .647-.29.647-.647v-7.16a.648.648 0 0 0-.647-.647h-3.205a.648.648 0 0 0-.647.648v7.159c0 .357.29.647.647.647z" fill="currentColor"/></g></svg>
								</span>
								<span class="arrow"></span>
							</a>
							<ul class="fn_submenu_toggle submenu">
								<li {if in_array($smarty.get.module, array("StatsAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=StatsAdmin">
										<span class="icon-thumbnail">
											<i class="icon-pie-chart icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_multiimport_title title">{$btr->stats_orders|escape}</span>
									</a>
								</li>
								<li {if in_array($smarty.get.module, array("ReportStatsAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=ReportStatsAdmin">
										<span class="icon-thumbnail">
											<i class="icon-chart icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_multiimport_title title">{$btr->left_products_stat_title|escape}</span>
									</a>
								</li>
								<li {if in_array($smarty.get.module, array("CategoryStatsAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=CategoryStatsAdmin">
										<span class="icon-thumbnail">
											<i class="icon-list icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_multiimport_title title">{$btr->left_categories_stat_title|escape}</span>
									</a>
								</li>
							</ul>
						</li>
						{/if}
                        {if in_array('seo', $manager->permissions)}
                        <li class="{if in_array($smarty.get.module, array("SeoAdmin"))}open active{/if}  fn_item_sub_switch nav-dropdown">
                            <a class="nav-link fn_item_switch nav-dropdown-toggle" href="javascript:;">
                                <span class="left_seo title">{$btr->left_seo|escape}</span>
                                <span class="icon-thumbnail">
                                    <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 489.25 489.25" width="20px" height="20px"><path d="M240.25,216.55c-4-1.1-8.1-1.7-12.4-1.7c-25.7,0-46.6,20.9-46.6,46.6c0,25.7,20.9,46.6,46.6,46.6s46.6-20.9,46.6-46.6    c0-4.3-0.6-8.5-1.7-12.4l129.8-129.8l21,2.8l65.7-65.7l-49.7-6.6l-6.6-49.7l-65.7,65.7l2.8,21L240.25,216.55z" fill="currentColor"/><path d="M232.85,171.95l38.4-38.4c-47.1-16-101.4-5.2-138.9,32.4c-52.7,52.7-52.7,138.3,0,191s138.3,52.7,191,0    c37.6-37.6,48.4-91.8,32.4-139l-38.4,38.4c1.4,24.6-7.3,49.7-26.1,68.5c-35,35-91.8,35-126.8,0s-35-91.8,0-126.8    C183.25,179.25,208.25,170.55,232.85,171.95z" fill="currentColor"/><path d="M388.85,184.95c31.5,66.2,19.8,147.7-35,202.5c-69.6,69.6-182.4,69.6-252,0s-69.6-182.4,0-252    c54.8-54.8,136.3-66.4,202.5-35l36.7-36.7c-87-49.9-200-37.7-274.3,36.6c-89,89-89,233.2,0,322.1c89,89,233.2,89,322.1,0    c74.3-74.3,86.5-187.3,36.6-274.3L388.85,184.95z" fill="currentColor"/></svg>
                                </span>
                                <span class="arrow"></span>
                            </a>
                            <ul class="fn_submenu_toggle submenu fn_sort_menu_item">
                                <li {if in_array($smarty.get.module, array("SeoAdmin"))}class="active"{/if}>
                                    <a class="nav-link" href="index.php?module=SeoAdmin">
                                        <span class="icon-thumbnail">
                                            <i class="icon-target icons font-lg d-block mt-4"></i> 
                                        </span>
                                        <span class="left_seo_patterns_title title">{$btr->seo_automation|escape}</span>
                                    </a>
                                </li>
                            </ul>
                        </li>
                        {/if}
						{if in_array('design', $manager->permissions)}
						<li class="{if in_array($smarty.get.module, array("ThemeAdmin","TemplatesAdmin","StylesAdmin","ImagesAdmin","TranslationsAdmin","TranslationAdmin"))}open active{/if}   fn_item_sub_switch nav-dropdown">
							<a class="nav-link fn_item_switch nav-dropdown-toggle" href="javascript:;">
								<span class="left_design title">{$btr->left_design|escape}</span>
								<span class="icon-thumbnail">
									<svg width="20" height="20" viewBox="0 0 22 21" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g fill="none"><g transform="translate(.595 15.37)"><path fill="currentColor" d="M0 2.625h6.454v2.151H4.733v.86h11.186v-.86h-1.721v-2.15h6.453V.041H0v2.583"/></g><path d="M9.896 4.775c.507-.5 1.232-1.163 2.035-1.838H.595v11.615h20.652V2.937h-3.845c-.204.342-.451.718-.748 1.138-.161.228-.333.462-.514.7h3.455v8h-11.1c-.604.496-1.463.916-2.637.916-.454 0-.935-.065-1.429-.193a.919.919 0 0 1-.67-.723H2.595v-8h7.3z" fill="currentColor"/><g fill="currentColor"><path d="M10.64 9.232L8.79 7.38c-.589.906-.578 1.454-.308 1.843a1.295 1.295 0 0 0-1.028-.304c-1.25.188-1.445 1.695-1.445 1.695A2.473 2.473 0 0 1 4.63 12.57c-.042.02-.031.085.014.096 2.341.608 3.535-.592 4.051-1.4.277-.433.385-.97.202-1.45l-.008-.02a1.407 1.407 0 0 0-.18-.322c.393.332.955.392 1.93-.241M9.307 6.68l2.033 2.035c.354-.29.749-.65 1.196-1.097 2.356-2.356 5.212-6.166 4.622-6.755-.589-.59-4.399 2.265-6.756 4.622-.447.447-.805.842-1.095 1.196"/></g></g></svg>
								</span>
								<span class="arrow"></span>
							</a>
							<ul class="fn_submenu_toggle submenu">
								<li {if in_array($smarty.get.module, array("ThemeAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=ThemeAdmin">
										<span class="icon-thumbnail">
											<i class="icon-screen-desktop icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_theme_title title">{$btr->left_theme_title|escape}</span>
									</a>
								</li>
								<li {if in_array($smarty.get.module, array("TemplatesAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=TemplatesAdmin">
										<span class="icon-thumbnail">
											<i class="icon-note  icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_template_title title">{$btr->left_template_title|escape}</span>
									</a>
								</li>
								<li {if in_array($smarty.get.module, array("StylesAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=StylesAdmin">
										<span class="icon-thumbnail">
											<i class="icon-magic-wand  icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_style_title title">{$btr->left_style_title|escape}</span>
									</a>
								</li>
								<li {if in_array($smarty.get.module, array("ImagesAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=ImagesAdmin">
										<span class="icon-thumbnail">
											<i class="icon-picture   icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_images_title title">{$btr->left_images_title|escape}</span>
									</a>
								</li>
                                <li {if in_array($smarty.get.module, array("TranslationsAdmin","TranslationAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=TranslationsAdmin">
										<span class="icon-thumbnail">
											<i class="icon-globe icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_images_title title">{$btr->left_translations_title|escape}</span>
									</a>
								</li>
							</ul>
						</li>
						{/if}
						{if in_array('banners', $manager->permissions)}
						<li class="{if in_array($smarty.get.module, array("BannersAdmin","BannerAdmin","BannersImagesAdmin","BannersImageAdmin"))}open active{/if} {if $banners_image->id}open active{/if}  fn_item_sub_switch nav-dropdown">
							<a class="nav-link fn_item_switch nav-dropdown-toggle" href="javascript:;">
								<span class="left_banners title">{$btr->left_banners|escape}</span>
								<span class="icon-thumbnail">
									<svg width="20" height="20" viewBox="0 0 24 15" xmlns="http://www.w3.org/2000/svg"><path d="M.918.04h22.164v14.92H.918V.04zM2.2 1.349v12.344h19.614V1.348H2.2zm1.616 5.939l3.968-3.608v7.216L3.816 7.287zm16.475 0l-4 3.636V3.651l4 3.636z" fill="currentColor"/></svg>
								</span>
								<span class="arrow"></span>
							</a>
							<ul class="fn_submenu_toggle submenu">
								<li {if in_array($smarty.get.module, array("BannersAdmin","BannerAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=BannersAdmin&do=groups">
										<span class="icon-thumbnail">
											<i class="icon-frame   icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_banners_title title">{$btr->left_banners_title|escape}</span>
									</a>
								</li>
								<li {if in_array($smarty.get.module, array("BannersImagesAdmin","BannersImageAdmin"))}class="active"{/if} {if $banners_image->id}class="active"{/if}>
									<a class="nav-link" href="index.php?module=BannersImagesAdmin">
										<span class="icon-thumbnail">
											<i class="icon-picture   icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_banners_images_title title">{$btr->left_banners_images_title|escape}</span>
									</a>
								</li>
							</ul>
						</li>
						{/if}
						{if in_array('settings', $manager->permissions) || in_array('currency', $manager->permissions) || in_array('delivery', $manager->permissions) || in_array('payment', $manager->permissions) || in_array('managers', $manager->permissions)}
						<li class="{if in_array($smarty.get.module, array("SettingsAdmin","CurrencyAdmin","DeliveriesAdmin","DeliveryAdmin","PaymentMethodsAdmin","PaymentMethodAdmin","ManagersAdmin","ManagerAdmin","SettingsFeedAdmin","LanguagesAdmin","LanguageAdmin"))}open active{/if}  fn_item_sub_switch nav-dropdown">
							<a class="nav-link fn_item_switch nav-dropdown-toggle" href="javascript:;">
								<span class="left_settings title">{$btr->left_settings|escape}</span>
								<span class="icon-thumbnail">
									<svg width="20" height="20" viewBox="0 0 19 20" xmlns="http://www.w3.org/2000/svg"><path d="M9.72 13.252c.579 0 1.12-.149 1.626-.446a3.364 3.364 0 0 0 1.202-1.191A3.095 3.095 0 0 0 12.994 10c0-.58-.149-1.121-.446-1.626a3.336 3.336 0 0 0-1.202-1.203 3.153 3.153 0 0 0-1.626-.445c-.58 0-1.118.148-1.615.445a3.364 3.364 0 0 0-1.192 1.203A3.153 3.153 0 0 0 6.468 10c0 .58.148 1.117.445 1.615.297.497.694.894 1.192 1.191a3.095 3.095 0 0 0 1.615.446zm6.927-2.339l1.937 1.515c.09.074.141.17.156.29a.525.525 0 0 1-.067.333l-1.87 3.208a.407.407 0 0 1-.234.2.493.493 0 0 1-.323-.022l-2.294-.913c-.594.43-1.122.735-1.582.913l-.334 2.428a.566.566 0 0 1-.167.29.403.403 0 0 1-.278.11H7.849a.403.403 0 0 1-.279-.11.453.453 0 0 1-.145-.29l-.356-2.428c-.624-.252-1.143-.557-1.56-.913l-2.315.913c-.238.104-.424.045-.557-.178L.766 13.05a.525.525 0 0 1-.067-.334.433.433 0 0 1 .156-.29l1.96-1.514A6.964 6.964 0 0 1 2.77 10c0-.4.015-.705.045-.913L.855 7.572a.433.433 0 0 1-.156-.29.525.525 0 0 1 .067-.333l1.87-3.208c.134-.223.32-.282.558-.178l2.316.913a7.19 7.19 0 0 1 1.56-.913l.355-2.428a.453.453 0 0 1 .145-.29.403.403 0 0 1 .279-.11h3.742c.103 0 .196.036.278.11.082.075.137.171.167.29l.334 2.428c.58.223 1.106.527 1.582.913l2.294-.913a.493.493 0 0 1 .323-.022c.096.03.174.096.234.2l1.87 3.208c.06.103.082.215.067.334a.433.433 0 0 1-.156.29l-1.937 1.514c.03.208.044.512.044.913 0 .4-.015.705-.044.913z" fill="currentColor"/></svg>
								</span>
								<span class="arrow"></span>
							</a>
							<ul class="fn_submenu_toggle submenu">
								{if in_array('settings', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("SettingsAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=SettingsAdmin">
										<span class="icon-thumbnail">
											<i class="icon-equalizer icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_setting_general_title title">{$btr->left_settings|escape}</span>
									</a>
								</li>
								{/if}
                                {if in_array('managers', $manager->permissions)}
                                <li {if in_array($smarty.get.module, array("SettingsFeedAdmin"))}class="active"{/if}>
                                    <a class="nav-link" href="index.php?module=SettingsFeedAdmin">
                                        <span class="icon-thumbnail">
                                            <i class="icon-share-alt icons font-lg d-block mt-4"></i>
                                        </span>
                                        <span class="left_setting_feed_title title">{$btr->left_setting_feed_title|escape}</span>
                                    </a>
                                </li>
                                {/if}
								{if in_array('currency', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("CurrencyAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=CurrencyAdmin">
										<span class="icon-thumbnail">
											<i class="icon-refresh   icons font-lg d-block mt-4"></i>
										</span>
										<span class="left_currency_title title">{$btr->left_currency_title|escape}</span>
									</a>
								</li>
								{/if}
								{if in_array('delivery', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("DeliveriesAdmin","DeliveryAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=DeliveriesAdmin">
										<span class="icon-thumbnail">
											<i class="icon-plane   icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_delivery_title title">{$btr->general_shipping|escape}</span>
									</a>
								</li>
								{/if}
								{if in_array('payment', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("PaymentMethodsAdmin","PaymentMethodAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=PaymentMethodsAdmin">
										<span class="icon-thumbnail">
											<i class="icon-credit-card icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_payment_title title">{$btr->order_payment_selected|escape}</span>
									</a>
								</li>
								{/if}
								{if in_array('managers', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("ManagersAdmin","ManagerAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=ManagersAdmin">
										<span class="icon-thumbnail">
											<i class="icon-user icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_managers_title title">{$btr->left_managers_title|escape}</span>
									</a>
								</li>
								{/if}
                                {if in_array('managers', $manager->permissions)}
								<li {if in_array($smarty.get.module, array("LanguagesAdmin","LanguageAdmin"))}class="active"{/if}>
									<a class="nav-link" href="index.php?module=LanguagesAdmin">
										<span class="icon-thumbnail">
											<i class="icon-flag icons font-lg d-block mt-4"></i> 
										</span>
										<span class="left_managers_title title">{$btr->left_languages_title|escape}</span>
									</a>
								</li>
								{/if}
							</ul>
						</li>
						{/if}
					</ul>
				</div>
			</div>
		</div>
	</nav>
	<div id="content-scroll" class="page-container">
		<a href="{$config->root_url}/{$lang_link}" class="admin_bookmark"></a>
		<header class="navbar">
			<div class="container-fluid">
				<div id="mobile_menu" class="fn_mobile_menu hidden-xl-up  text_white">
					{include file='svg_icon.tpl' svgId='mobile_menu'}
				</div>
				<div class="admin_switches">
					<div class="box_adswitch">
						<a class="btn_admin" href="{$config->root_url}/{$lang_link}">
							{include file='svg_icon.tpl' svgId='icon_desktop'}
							<span class="">{$btr->index_go_to_site|escape}</span>
						</a>
					</div>
				</div>
				<div id="mobile_menu_right" class="fn_mobile_menu_right hidden-md-up  text_white float-xs-right">
					{include file='svg_icon.tpl' svgId='mobile_menu2'}
				</div>
				<div id="quickview" class="fn_quickview">
					<div class="sidebar_header hidden-md-up">
						<span class="fn_switch_quickview menu_switch">
							<span class="menu_hamburger"></span>
						</span>
						<a class="logo_box">
							<img src="design/images/logo_title.png" alt="TurboCMS"/>
						</a>
					</div>
					<div class="admin_exit hidden-sm-down">
						<a href="{$config->root_url}?logout">
							<span class="hidden-lg-down">{$btr->index_exit|escape}</span>
							{include file='svg_icon.tpl' svgId='exit'}
						</a>
					</div>
					<div class="admin_notification">
						<div class="notification_inner">
							<span class="notification_title" href="">
								<span class="quickview_hidden">{$btr->index_notifications|escape}</span>
								{include file='svg_icon.tpl' svgId='notify'}
								{if $all_counter}
								<span class="counter">
									{$all_counter}  
								</span>
								{/if}
							</span>
							<div class="notification_toggle ui_sub_menu--right-arrow">
								{if $new_comments_counter || $new_callbacks_counter || $new_feedbacks_counter || $new_subscribes_counter}
								{if in_array('comments', $manager->permissions)}
								{if $new_comments_counter > 0}
								<div class="notif_item">
									<a href="index.php?module=CommentsAdmin" class="l_notif">
										<span class="notif_icon boxed_green">
											{include file='svg_icon.tpl' svgId='left_comments'}
										</span>
										<span class="notif_title">{$btr->general_comments|escape}</span>
									</a>
									<span class="notif_count">{$new_comments_counter}</span>
								</div>
								{/if}
								{/if}
								{if in_array('feedbacks', $manager->permissions)}
								{if $new_feedbacks_counter > 0}
								<div class="notif_item">
									<a href="index.php?module=FeedbacksAdmin" class="l_notif">
										<span class="notif_icon boxed_yellow">
											{include file='svg_icon.tpl' svgId='email'}
										</span>
										<span class="notif_title">{$btr->general_feedback|escape}</span>
									</a>
									<span class="notif_count">{$new_feedbacks_counter}</span>
								</div>
								{/if}
								{/if}
								{if in_array('subscribes', $manager->permissions)}
								{if $new_subscribes_counter > 0}
								<div class="notif_item">
									<a href="index.php?module=SubscribesAdmin" class="l_notif">
										<span class="notif_icon boxed_subscribes">
											{include file='svg_icon.tpl' svgId='paper_plane'}
										</span>
										<span class="notif_title">{$btr->general_subscribes|escape}</span>
									</a>
									<span class="notif_count">{$new_subscribes_counter}</span>
								</div>
								{/if}
								{/if}
								{if in_array('callbacks', $manager->permissions)}
								{if $new_callbacks_counter > 0}
								<div class="notif_item">
									<a href="index.php?module=CallbacksAdmin" class="l_notif">
										<span class="notif_icon boxed_info">
											{include file='svg_icon.tpl' svgId='phone'}
										</span>
										<span class="notif_title">{$btr->general_callback|escape}</span>
									</a>
									<span class="notif_count">{$new_callbacks_counter}</span>
								</div>
								{/if}
								{/if}
								{else}
								<div class="notif_item">
									<span class="notif_title">{$btr->index_no_notification|escape}</span>
								</div>
								{/if}    
							</div>
						</div>
					</div>
					<div class="admin_notification">
						<div class="notification_inner">
							<span class="notification_title" href="index.php?module=OrdersAdmin">
								<span class="quickview_hidden">{$btr->general_orders|escape}</span>
								{include file='svg_icon.tpl' svgId='cart'}
								{if $new_orders_counter}
								<span class="counter_cart">
									{$new_orders_counter}   
								</span>
								{/if}
							</span>
							<div class="notification_toggle ui_sub_menu--right-arrow-cart">
								{if $new_orders_counter > 0}
								<div class="notif_item">
									<a href="index.php?module=OrdersAdmin" class="l_notif">
										<span class="notif_icon boxed_notify">
											{include file='svg_icon.tpl' svgId='left_orders'}
										</span>
										<span class="notif_title">{$btr->general_orders|escape}</span>
									</a>
									<span class="notif_count">{$new_orders_counter}</span>
								</div>
								{else}
								<div class="notif_item">
									<span class="notif_title">{$btr->index_no_new_orders|escape}</span>
								</div>
								{/if}
							</div>
						</div>
					</div>
                    <div class="admin_languages">
                        <div class="languages_inner">
                            <span class="languages_title hidden-md-up">{$btr->general_languages|escape}</span>
                            {include file="include_languages.tpl"}
                        </div>
                    </div>
					
				</div>
			</div>
		</header>
		<div class="main">
			<div class="container-fluid animated fadeIn">
				{if $content}
				{$content}
				{else}
				<div class="row">
					<div class="col-lg-12 col-md-12 col-sm-12 mt-1">
						<div class="boxed boxed_warning">
							<div class="heading_box">
								{$btr->general_no_permission}
							</div>
						</div>
					</div>
				</div>
				{/if}
				<div style="display:none;" class="nav_up" id="nav_up"><i class="fa fa-arrow-up"></i></div>
				<div style="display:none;" class="nav_down" id="nav_down"><i class="fa fa-arrow-down"></i></div>
			</div>
		</div>
		<footer id="footer" class="app-footer">
			<div class="col-md-12 font_12 text_dark">
				<div class="float-md-right">
					<a href="https://turbo-cms.com">TurboCMS </a> &copy; TurboShop {$smarty.now|date_format:"%Y"} v.{$config->version} | {$manager->login|escape}
				</div>
			</div>
		</footer>
		<div id="fn_action_modal" class="modal fade show" role="document">
			<div class="modal-dialog modal-md">
				<div class="modal-content">
					<div class="card-header">
						<div class="heading_modal">{$btr->index_confirm|escape}</div>
					</div>
					<div class="modal-body">
						<button type="submit" class="btn btn_small btn_green fn_submit_delete mx-h">
							{include file='svg_icon.tpl' svgId='checked'}
							<span>{$btr->index_yes|escape}</span>
						</button>
						<button type="button" class="btn btn_small btn-danger fn_dismiss_delete mx-h" data-dismiss="modal">
							{include file='svg_icon.tpl' svgId='delete'}
							<span>{$btr->index_no|escape}</span>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="fn_fast_save">
		<button type="submit" class="btn btn_small btn_green">
			{include file='svg_icon.tpl' svgId='checked'}
			<span>{$btr->general_apply|escape}</span>
		</button>
	</div>
	{*main scripts*}
	<script>
		$(function(){
			if($('form.fn_fast_button').size()>0){
				$('input,textarea,select, .dropdown-toggle').bind('keyup change dragover click',function(){
					$('.fn_fast_save').show();
				});
				$('.fn_fast_save').on('click', function () {
					$('body').find("form.fn_fast_button").trigger('submit');
				});
			}
			/* Check */
			if($('.fn_check_all').size()>0){
				$(document).on('change','.fn_check_all',function(){
					if($(this).is(":checked")) {
						$('.hidden_check').each(function () {
							if(!$(this).is(":checked")) {
								$(this).trigger("click");
							}
						});
						} else {
						$('.hidden_check').each(function () {
							if($(this).is(":checked")) {
								$(this).trigger("click");
							}
						})
					}
				});
			}
			/* Catalog items toggle */
			if($('.fn_item_switch').size()>0){
				$('.fn_item_switch').on('click',function(e){
					var parent = $(this).closest("ul"),
					li = $(this).closest(".fn_item_sub_switch"),
					sub = li.find(".fn_submenu_toggle");
					if(li.hasClass("open active")){
						sub.slideUp(200, function () {
							li.removeClass("open active")
						})
						} else {
						parent.find("li.open").children(".fn_submenu_toggle").slideUp(200),
						parent.find("li.open").removeClass("open active"),
						li.children(".arrow").addClass("open active"),
						sub.slideDown(200, function () {
							li.addClass("open active")
						})
					}
				});
			}
			/* Left menu toggle */
			if($('.fn_switch_menu').size()>0){
				$(document).on("click", ".fn_switch_menu", function () {
					$("body").toggleClass("menu-pin");
				});
				$(document).on("click", ".fn_mobile_menu", function () {
					$("body").toggleClass("menu-pin");
					$(".fn_quickview").removeClass("open");
				});
			}
			/* Right menu toggle */
			if($('.fn_switch_quickview').size()>0){
				$(document).on("click", ".fn_mobile_menu_right", function () {
					$(this).next().toggleClass("open");
					$("body").removeClass("menu-pin");
				});
				$(document).on("click", ".fn_switch_quickview", function () {
					$(this).closest(".fn_quickview").toggleClass("open");
				});
			}
			/* Delete images for products */
			if($('.images_list').size()>0){
				$('.fn_delete').on('click',function(){
					if($('.fn_accept_delete').size()>0){
						$('.fn_accept_delete').val('1');
						$(this).closest("li").fadeOut(200, function() {
							$(this).remove();
						});
						} else {
						$(this).closest("li").fadeOut(200, function() {
							$(this).remove();
						});
					}
					return false;
				});
			}
			/* Input_file */
			if($('.input_file').size()>0){
				document.querySelector("html").classList.add('fn_input_file');
				
				var fileInput  = document.querySelector( ".input_file" ),
				button     = document.querySelector( ".input_file_trigger" ),
				the_return = document.querySelector(".input_file_return");
				
				button.addEventListener( "keydown", function( event ) {
					if ( event.keyCode == 13 || event.keyCode == 32 ) {
						fileInput.focus();
					}
				});
				button.addEventListener( "click", function( event ) {
					fileInput.focus();
					return false;
				});
				fileInput.addEventListener( "change", function( event ) {
					the_return.innerHTML = this.value;
				});
			}
			/* Initializing the scrollbar */
			if($('.scrollbar-inner').size()>0){
				$('.scrollbar-inner').scrollbar();
			}
			if($(window).width() < 1199 ){
				if($('.scrollbar-variant').size()>0){
					$('.scrollbar-variant').scrollbar();
				}
			}
			/* Initializing sorting */
			if($(".sortable").size()>0) {
				{literal}
				var el = document.querySelectorAll(".sortable");
				for (var i = 0; i < el.length; i++) {
					var sortable = Sortable.create(el[i], {
						handle: ".move_zone",  // Drag handle selector within list items
						sort: true,  // sorting inside list
						animation: 150,  // ms, animation speed moving items when sorting, `0` — without animation
						ghostClass: "sortable-ghost",  // Class name for the drop placeholder
						chosenClass: "sortable-chosen",  // Class name for the chosen item
						dragClass: "sortable-drag",  // Class name for the dragging item
						scrollSensitivity: 30, // px, how near the mouse must be to an edge to start scrolling.
						scrollSpeed: 10, // px
						// Changed sorting within list
						onUpdate: function (evt) {
							if ($(".product_images_list").size() > 0) {
								var itemEl = evt.item;  // dragged HTMLElement
								if ($(itemEl).closest(".fn_droplist_wrap").data("image") == "product") {
									$(".product_images_list").find("li.first_image").removeClass("first_image");
									$(".product_images_list").find("li:nth-child(2)").addClass("first_image");
								}
							}
						},
					});
				}
				{/literal}
			}
			/* Call an ajax entity update */
			if($(".fn_ajax_action").size()>0){
				$(document).on("click",".fn_ajax_action",function () {
					ajax_action($(this));
				});
			}
			if($(".fn_parent_image").size()>0 ) {
				var image_wrapper = $(".fn_new_image").clone(true);
				$(".fn_new_image").remove();
				$(document).on("click", '.fn_delete_item', function () {
					$(".fn_upload_image").removeClass("hidden");
					$(".fn_accept_delete").val(1);
					$(this).closest(".fn_image_wrapper").remove()
				});
				if(window.File && window.FileReader && window.FileList) {
					$(".fn_upload_image").on('dragover', function (e){
						e.preventDefault();
						$(this).css('background', '#bababa');
					});
					$(".fn_upload_image").on('dragleave', function(){
						$(this).css('background', '#f8f8f8');
					});
					function handleFileSelect(evt){
						var parent = $(".fn_parent_image");
						var files = evt.target.files;
						for (var i = 0, f; f = files[i]; i++) {
							if (!f.type.match('image.*')) {
								continue;
							}
							var reader = new FileReader();
							reader.onload = (function(theFile) {
								return function(e) {
									clone_image = image_wrapper.clone(true);
									clone_image.find("img").attr("src", e.target.result);
									clone_image.find("img").attr("onerror", '$(this).closest(\"div\").remove()');
									clone_image.appendTo(parent);
									$(".fn_upload_image").addClass("hidden");
								};
							})(f);
							reader.readAsDataURL(f);
						}
						$(".fn_upload_image").removeAttr("style");
					}
					$(document).on('change','.dropzone_image',handleFileSelect);
				}
			}
			if($(".fn_parent_image2").size()>0 ) {
				var image_wrapper = $(".fn_new_image2").clone(true);
				$(".fn_new_image2").remove();
				$(document).on("click", '.fn_delete_item', function () {
					$(".fn_upload_image2").removeClass("hidden");
					$(".fn_accept_delete").val(1);
					$(this).closest(".fn_image_wrapper2").remove()
				});
				if(window.File && window.FileReader && window.FileList) {
					$(".fn_upload_image2").on('dragover', function (e){
						e.preventDefault();
						$(this).css('background', '#bababa');
					});
					$(".fn_upload_image2").on('dragleave', function(){
						$(this).css('background', '#f8f8f8');
					});
					function handleFileSelect(evt){
						var parent = $(".fn_parent_image2");
						var files = evt.target.files;
						for (var i = 0, f; f = files[i]; i++) {
							if (!f.type.match('image.*')) {
								continue;
							}
							var reader = new FileReader();
							reader.onload = (function(theFile) {
								return function(e) {
									clone_image = image_wrapper.clone(true);
									clone_image.find("img").attr("src", e.target.result);
									clone_image.find("img").attr("onerror", '$(this).closest(\"div\").remove()');
									clone_image.appendTo(parent);
									$(".fn_upload_image2").addClass("hidden");
								};
							})(f);
							reader.readAsDataURL(f);
						}
						$(".fn_upload_image2").removeAttr("style");
					}
					$(document).on('change','.dropzone_image2',handleFileSelect);
				}
			}
		});
		if($('.fn_remove').size() > 0) {
			// Confirm deletion
			/*
			* modal window function with delete confirmation
			* takes an argument $ this - in fact, the delete button itself
			* the function is called directly in the tpl files
			* */
			function success_action ($this){
				$(document).on('click','.fn_submit_delete',function(){
					$('.fn_form_list input[type="checkbox"][name*="check"]').attr('checked', false);
					$this.closest(".fn_form_list").find('select[name="action"] option[value=delete]').attr('selected', true);
					$this.closest(".fn_row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
					if ( !(/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)) ) {
						$this.closest(".fn_row").find('input[type="checkbox"][name*="check"]').trigger("click");
					}
					$this.closest(".fn_form_list").submit();
				});
				$(document).on('click','.fn_dismiss_delete',function(){
					$('.fn_form_list input[type="checkbox"][name*="check"]').attr('checked', false);
					$this.closest(".fn_form_list").find('select[name="action"] option[value=delete]').removeAttr('selected');
					return false;
				});
			}
		}
		{literal}
		if($(".fn_ajax_action").size()>0) {
			/* Function for ajax update of fields
			* state - the state of the object (enabled / disabled)
			* id - id of the updated entity
			* module - type of entity
			* action - updated field (field in the database)
			* */
			function ajax_action($this) {
				var state, module, session_id,action,id;
				state = $this.hasClass("fn_active_class") ? 0:1;
				id = parseInt($this.data('id'));
				module = $this.data("module");
				action = $this.data("action");
				session_id = '{/literal}{$smarty.session.id}{literal}';
				toastr.options = {
					closeButton: true,
					newestOnTop: true,
					progressBar: true,
					positionClass: 'toast-top-right',
					preventDuplicates: false,
					onclick: null
				};
				$.ajax({
					type: "POST",
					dataType: 'json',
					url: "ajax/update_object.php",
					data: {
						object : module,
						id : id,
						values: {[action]: state},
						session_id : session_id
					},
					success: function(data){
						var msg = "";
						if(data){
							$this.toggleClass("fn_active_class");
							$this.removeClass('unapproved');
							toastr.success(msg, "{/literal}{$btr->general_success|escape}{literal}");
							if(action == "approved" || action == "processed") {
								$this.closest("div").find(".fn_answer_btn").show();
								$this.closest(".fn_row").removeClass('unapproved');
							}
							} else {
							toastr.error(msg, "{/literal}{$btr->general_error|escape}{literal}");
						}
					}
				});
				return false;
			}
		}
		{/literal}
		/*
			* Metadata generation functions
		* */
		if($('input').is('.fn_meta_field')) {
			$(window).on("load", function() {
				// Autocomplete meta tags
				header_touched = true;
				meta_title_touched = true;
				meta_keywords_touched = true;
				meta_description_touched = true;
				if($('input[name="header"]').val() == generate_header() || $('input[name="header"]').val() == '')
				header_touched = false;
				if($('input[name="meta_title"]').val() == generate_meta_title() || $('input[name="meta_title"]').val() == '')
				meta_title_touched = false;
				if($('input[name="meta_keywords"]').val() == generate_meta_keywords() || $('input[name="meta_keywords"]').val() == '')
				meta_keywords_touched = false;
				if($('textarea[name="meta_description"]').val() == generate_meta_description() || $('textarea[name="meta_description"]').val() == '')
				meta_description_touched = false;
				$('input[name="header"]').change(function() { header_touched = true; });
				$('input[name="meta_title"]').change(function() { meta_title_touched = true; });
				$('input[name="meta_keywords"]').change(function() { meta_keywords_touched = true; });
				$('textarea[name="meta_description"]').change(function() { meta_description_touched = true; });
                
                $('#fn_meta_title_counter').text( '('+$('input[name="meta_title"]').val().length+')' );
                $('#fn_meta_description_counter').text( '('+$('textarea[name="meta_description"]').val().length+')' );
                
				$('input[name="name"]').keyup(function() { set_meta(); });
				$('input[name="author"]').keyup(function() { set_meta(); });
                $('input[name="meta_title"]').keyup(function() { $('#fn_meta_title_counter').text( '('+$('input[name="meta_title"]').val().length+')' ); });
                $('textarea[name="meta_description"]').keyup(function() { $('#fn_meta_description_counter').text( '('+$('textarea[name="meta_description"]').val().length+')' ); });
                
				if($(".fn_meta_brand").size()>0) {
					$("select[name=brand_id]").on("change",function () {
						set_meta();
					})
				}
				if($(".fn_meta_categories").size()>0) {
					$(".fn_meta_categories").on("change",function () {
						set_meta();
					})
				}
			});
			function set_meta() {
				if(!header_touched)
				$('input[name="header"]').val(generate_header());
				if(!meta_title_touched)
				$('input[name="meta_title"]').val(generate_meta_title());
				if(!meta_keywords_touched)
				$('input[name="meta_keywords"]').val(generate_meta_keywords());
				if(!meta_description_touched)
				$('textarea[name="meta_description"]').val(generate_meta_description());
				if(!$('#block_translit').is(':checked'))
				$('input[name="url"]').val(generate_url());
			}
			function generate_header(){
				name = $('input[name="name"]').val();
				return name;
			}
			function generate_meta_title() {
				name = $('input[name="name"]').val();
                $('#fn_meta_title_counter').text( '('+name.length+')' );
				return name;
			}
			function generate_meta_keywords() {
				name = $('input[name="name"]').val();
				result = name;
				if($('input[name="author"]').size() > 0) {
					author = $('input[name="author"]').val();
					result += ', ' + author;
				}	
				if($(".fn_meta_brand").size() > 0) {
					brand = $('select[name="brand_id"] option:selected').data('brand_name');
					if (typeof(brand) == 'string' && brand != '')
					result += ', ' + brand;
				}
				$('select[name="categories[]"]').each(function(index) {
					c = $(this).find('option:selected').attr('category_name');
					if(typeof(c) == 'string' && c != '')
					result += ', '+c;
				}); 
				return result;
			}
			function generate_meta_description() {
				if(typeof(tinyMCE.get("fn_editor")) =='object') {
					description = tinyMCE.get("fn_editor").getContent().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ").replace(/^\s+|\s+$/g, '').substr(0, 512);
					$('#fn_meta_description_counter').text( '('+description.length+')');
                    return description;
					} else {
					return $('.fn_editor_class').val().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ").replace(/^\s+|\s+$/g, '').substr(0, 512);
				}
			}
			function generate_url() {
				url = $('input[name="name"]').val();
				url = url.replace(/[\s]+/gi, '-');
				url = translit(url);
				url = url.replace(/[^0-9a-z_\-]+/gi, '').toLowerCase();
				return url;
			}
			function translit(str) {
				var ru=("А-а-Б-б-В-в-Ґ-ґ-Г-г-Д-д-Е-е-Ё-ё-Є-є-Ж-ж-З-з-И-и-І-і-Ї-ї-Й-й-К-к-Л-л-М-м-Н-н-О-о-П-п-Р-р-С-с-Т-т-У-у-Ф-ф-Х-х-Ц-ц-Ч-ч-Ш-ш-Щ-щ-Ъ-ъ-Ы-ы-Ь-ь-Э-э-Ю-ю-Я-я").split("-")
				var en=("A-a-B-b-V-v-G-g-G-g-D-d-E-e-E-e-E-e-ZH-zh-Z-z-I-i-I-i-I-i-J-j-K-k-L-l-M-m-N-n-O-o-P-p-R-r-S-s-T-t-U-u-F-f-H-h-TS-ts-CH-ch-SH-sh-SCH-sch-'-'-Y-y-'-'-E-e-YU-yu-YA-ya").split("-")
				var res = '';
				for(var i=0, l=str.length; i<l; i++) {
					var s = str.charAt(i), n = ru.indexOf(s);
					if(n >= 0) { res += en[n]; }
					else { res += s; }
				}
				return res;
			}
		}
		/* Metadata generation functions end */
		$(window).on('load',function () {
			$("#countries_select").msDropdown({
				roundedBorder:false
			});
			/*
				* Tab script
			* */
			$('.tabs').each(function(i) {
				var cur_nav = $(this).find('.tab_navigation'),
				cur_tabs = $(this).find('.tab_container');
				if(cur_nav.children('.selected').size() > 0) {
					$(cur_nav.children('.selected').attr("href")).show();
					cur_tabs.css('height', cur_tabs.children($(cur_nav.children('.selected')).attr("href")).outerHeight());
					} else {
					cur_nav.children().first().addClass('selected');
					cur_tabs.children().first().show();
					cur_tabs.css('height', cur_tabs.children().first().outerHeight());
				}
			});
			$('.tab_navigation_link').click(function(e){
				e.preventDefault();
				if($(this).hasClass('selected')){
					return true;
				}
				var cur_nav = $(this).closest('.tabs').find('.tab_navigation'),
				cur_tabs = $(this).closest('.tabs').find('.tab_container');
				cur_tabs.children().hide();
				cur_nav.children().removeClass('selected');
				$(this).addClass('selected');
				$($(this).attr("href")).fadeIn(200);
				cur_tabs.css('height', cur_tabs.children($(this).attr("href")).outerHeight());
			});
			/* Tab script end*/
			/*
				* Information block folding script
			* */
			$(document).on("click", ".fn_toggle_card", function () {
				$(this).closest(".fn_toggle_wrap").find('.fn_icon_arrow').toggleClass('rotate_180');
				$(this).closest(".fn_toggle_wrap").find(".fn_card").slideToggle(500);
			});
			/*
				* Blocking link auto-generation
			* */
			$(document).on("click", ".fn_disable_url", function () {
				if($(".fn_url").attr("readonly")){
					$(".fn_url").removeAttr("readonly");
					} else {
					$(".fn_url").attr("readonly",true);
				}
				$(this).find('i').toggleClass("fa-unlock");
				$("#block_translit").trigger("click");
			});
			/* Blocking link auto-generation end*/
			if( /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) ) {
				$('.selectpicker').selectpicker('mobile');
			}
		});
	</script>
	{literal}
	<script>
		/* Scroll */
		$(function() {
			var $elem = $('#content-scroll');
			$('#nav_up').fadeIn('slow');
			$('#nav_down').fadeIn('slow');  
			$(window).bind('scrollstart', function(){
				$('#nav_up,#nav_down').stop().animate({'opacity':'0.2'});
			});
			$(window).bind('scrollstop', function(){
				$('#nav_up,#nav_down').stop().animate({'opacity':'1'});
			});
			$('#nav_down').click(
			function (e) {
				$('html, body').animate({scrollTop: $elem.height()}, 800);
			}
			);
			$('#nav_up').click(
			function (e) {
				$('html, body').animate({scrollTop: '0px'}, 800);
			}
			);
		});
	</script>
	{/literal}
	{if $product_images}<div id="popup_images"></div>{/if}
</body>
</html>