<?php

require_once('api/Turbo.php');

// Этот класс выбирает модуль в зависимости от параметра Section и выводит его на экран
class IndexAdmin extends Turbo
{
	// Соответсвие модулей и названий соответствующих прав
	private $modules_permissions = array(
		'DashboardAdmin'            => 'dashboard',
		'ProductsAdmin'             => 'products',
		'ProductAdmin'              => 'products',
		'CategoriesAdmin'           => 'categories',
		'CategoryAdmin'             => 'categories',
		'BrandsAdmin'               => 'brands',
		'BrandAdmin'                => 'brands',
		'FeaturesAdmin'             => 'features',
		'FeatureAdmin'              => 'features',
		'OrdersAdmin'               => 'orders',
		'OrderAdmin'                => 'orders',
		'OrdersLabelsAdmin'         => 'labels',
		'OrdersLabelAdmin'          => 'labels',
		'UsersAdmin'                => 'users',
		'UserAdmin'                 => 'users',
		'ExportUsersAdmin'          => 'users',
		'GroupsAdmin'               => 'groups',
		'GroupAdmin'                => 'groups',
		'CouponsAdmin'              => 'coupons',
		'CouponAdmin'               => 'coupons',
		'PagesAdmin'                => 'pages',
		'PageAdmin'                 => 'pages',
		'MenuAdmin'                 => 'menus',
		'BlogAdmin'                 => 'blog',
		'PostAdmin'                 => 'blog',
		'ArticlesCategoriesAdmin'   => 'blog',
		'ArticlesCategoryAdmin'     => 'blog',    
		'ArticlesAdmin'             => 'blog',
		'ArticleAdmin'              => 'blog',
		'CommentsAdmin'             => 'comments',
		'CommentAdmin'       		=> 'comments',
		'FeedbacksAdmin'            => 'feedbacks',
		'CallbacksAdmin'            => 'callbacks',
		'SubscribesAdmin'           => 'subscribes',
		'ImportAdmin'               => 'import',
        'ImportYmlAdmin'            => 'import',
		'ExportAdmin'               => 'export',
		'BackupAdmin'               => 'backup',
		'ClearAdmin'                => 'clear',
		'ReportStatsAdmin'          => 'stats',
        'CategoryStatsAdmin'        => 'stats',
		'ThemeAdmin'                => 'design',
		'StylesAdmin'               => 'design',
		'TemplatesAdmin'            => 'design',
		'ImagesAdmin'               => 'design',
        'SeoAdmin'                  => 'seo',
		'SettingsAdmin'             => 'settings',
        'SettingsFeedAdmin'         => 'settings',
		'CurrencyAdmin'             => 'currency',
		'DeliveriesAdmin'           => 'delivery',
		'DeliveryAdmin'             => 'delivery',
		'PaymentMethodAdmin'        => 'payment',
		'PaymentMethodsAdmin'       => 'payment',
		'BannersAdmin'              => 'banners',
		'BannerAdmin'               => 'banners',
		'BannersImagesAdmin'        => 'banners',
		'BannersImageAdmin'         => 'banners',
		'ManagersAdmin'             => 'managers',
		'ManagerAdmin'              => 'managers',
        'LanguageAdmin'             => 'languages',
		'LanguagesAdmin'            => 'languages',
		'TranslationAdmin'          => 'languages',
		'TranslationsAdmin'         => 'languages'
   );

	// Конструктор
	public function __construct()
	{
	    // Вызываем конструктор базового класса
		parent::__construct();
		
        // Перевод админки
        $backend_translations = $this->backend_translations;
        $file = "turbo/lang/".$this->settings->lang.".php";
        if (!file_exists($file)) {
            foreach (glob("turbo/lang/??.php") as $f) {
                $file = "turbo/lang/".pathinfo($f, PATHINFO_FILENAME).".php";
                break;
            }
        }
        require_once($file);
		
		$this->design->set_templates_dir('turbo/design/html');
		$this->design->set_compiled_dir('turbo/design/compiled');
		
		$this->design->assign('seo', $this->seo);
        $this->design->assign('settings', $this->settings);
		$this->design->assign('config',	$this->config);
        
		$is_mobile = $this->design->is_mobile();
		$is_tablet = $this->design->is_tablet();
		$this->design->assign('is_mobile',$is_mobile);
		$this->design->assign('is_tablet',$is_tablet);
        
        // Язык
        $languages = $this->languages->languages();
        $this->design->assign('languages', $languages);

        $lang_id = $this->languages->lang_id();
        $this->design->assign('lang_id', $lang_id);

        $lang_label = '';
		$lang_link = '';
        if($lang_id && $languages)$lang_label = $languages[$lang_id]->label;
		
		$first_lang = $this->languages->languages();
		$first_lang = reset($first_lang);
		if(isset($first_lang->id) && ($first_lang->id != $lang_id)) {
			$lang_link = $lang_label.'/';
		}
		
        $this->design->assign('lang_label', $lang_label);
		$this->design->assign('lang_link', $lang_link);
		
		// Администратор
		$this->manager = $this->managers->get_manager();
		$this->design->assign('manager', $this->manager);

 		// Берем название модуля из get-запроса
		$module = $this->request->get('module', 'string');
		$module = preg_replace("/[^A-Za-z0-9]+/", "", $module);
		
		// Если не запросили модуль - используем модуль первый из разрешенных
		if(empty($module) || !is_file('turbo/'.$module.'.php'))
		{
			foreach($this->modules_permissions as $m=>$p)
			{
				if($this->managers->access($p))
				{
					$module = $m;
					break;
				}
			}
		}
		if(empty($module))
			$module = 'ProductsAdmin';

		// Подключаем файл с необходимым модулем
		require_once('turbo/'.$module.'.php');  
        
        $this->design->assign('btr', $backend_translations);
		
		// Создаем соответствующий модуль
		if(class_exists($module))
			$this->module = new $module();
		else
			die("Error creating $module class");

	}

	function fetch()
	{
		$currency = $this->money->get_currency();
		$this->design->assign("currency", $currency);
		
		// Проверка прав доступа к модулю
		if(isset($this->modules_permissions[get_class($this->module)])
		&& $this->managers->access($this->modules_permissions[get_class($this->module)]))
		{
			$content = $this->module->fetch();
			$this->design->assign("content", $content);
		}
		else
		{
			$this->design->assign("content", "Permission denied");
		}

		// Счетчики для верхнего меню
		$new_orders_counter = $this->orders->count_orders(array('status'=>0));
		$this->design->assign("new_orders_counter", $new_orders_counter);
		
		$new_comments_counter = $this->comments->count_comments(array('approved'=>0));
		$this->design->assign("new_comments_counter", $new_comments_counter);
		  
		$new_feedbacks_counter = $this->feedbacks->count_feedbacks(array('processed'=>0));
		$this->design->assign("new_feedbacks_counter", $new_feedbacks_counter);

		$new_callbacks_counter = $this->callbacks->count_callbacks(array('processed'=>0));
		$this->design->assign("new_callbacks_counter", $new_callbacks_counter);
		  
		$new_subscribes_counter = $this->subscribes->count_subscribes(array('processed'=>0));
		$this->design->assign("new_subscribes_counter", $new_subscribes_counter);

		$this->design->assign("all_counter", $new_comments_counter+$new_feedbacks_counter+$new_callbacks_counter+$new_subscribes_counter);

		// Текущее меню
		$menu_id = $this->request->get('menu_id', 'integer'); 
		$menus = $this->pages->get_menus();
		$menu = $this->pages->get_menu($menu_id);
		$this->design->assign('menu', $menu);
		$this->design->assign('menus', $menus);
		
		// Создаем текущую обертку сайта (обычно index.tpl)
		$wrapper = $this->design->smarty->getTemplateVars('wrapper');
		if(is_null($wrapper))
			$wrapper = 'index.tpl';
			
		if(!empty($wrapper))
			return $this->body = $this->design->fetch($wrapper);
		else
			return $this->body = $content;
	}
}