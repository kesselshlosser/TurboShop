<?PHP

/**
 * Turbo CMS
 *
 * @author	Turbo CMS
 * @link	https://turbo-cms.com
 *
 * Базовый класс для всех View
 *
 */

require_once('api/Turbo.php');

class View extends Turbo
{
	/* Смысл класса в доступности следующих переменных в любом View */
	public $currency;
	public $currencies;
	public $user;
	public $group;
	public $page;
    public $language;
	public $lang_link;
	
	/* Класс View похож на синглтон, храним статически его инстанс */
	private static $view_instance;
	
	public function __construct()
	{
		parent::__construct();
		
		// Если инстанс класса уже существует - просто используем уже существующие переменные
		if(self::$view_instance)
		{
			$this->currency     = &self::$view_instance->currency;
			$this->currencies   = &self::$view_instance->currencies;
			$this->user         = &self::$view_instance->user;
			$this->group        = &self::$view_instance->group;	
			$this->page         = &self::$view_instance->page;
            $this->language     = &self::$view_instance->language;
			$this->lang_link    = &self::$view_instance->lang_link;
		}
		else
		{
			// Сохраняем свой инстанс в статической переменной,
			// чтобы в следующий раз использовать его
			self::$view_instance = $this;
            
            // Язык
            $lang_labels = array();

            $languages = $this->languages->languages();
            foreach($languages as $l)
                $lang_labels[]=$l->label;

            $get_lang = $_GET['lang_label'];

            if(!isset($get_lang) && !empty($lang_labels) && !in_array($get_lang, $lang_labels))
            {
	            $_GET['page_url'] = '404';
	            $_GET['module'] = 'PageView';
            }

            $lang_link = '';
            if($get_lang)
            {
                $this->language = $this->languages->languages(array('id'=>$this->languages->lang_id()));
                if(!is_object($this->language))
                {
	                $_GET['page_url'] = '404';
	                $_GET['module'] = 'PageView';
                    $this->language = reset($languages);
                    $this->languages->set_lang_id($this->language->id);
                }
                $lang_link = $this->language->label . '/';
            }
            else
            {
                $this->language = reset($languages);
                $this->languages->set_lang_id($this->language->id);
                //$_SESSION['lang_id'] = $this->language->id;
            }

            $this->design->assign('lang_link', $lang_link);
			$this->lang_link = $lang_link;

            //if(!empty($languages) && (empty($get_lang) || !isset($get_lang) || !in_array($get_lang, $lang_labels)))
            /*if(!empty($languages) && $_SERVER['REQUEST_URI'] == '/')
            {
                header("HTTP/1.1 301 Moved Permanently");
                header('Location: '.$this->config->root_url.'/'.reset($lang_labels));
                exit();
            }*/

            if(!empty($languages))
            {
                $first_lang = reset($languages);
                $ruri = explode('/',$_SERVER['REQUEST_URI']);
                $as = $first_lang->id !== $this->languages->lang_id() ? 2 : 1;

                if(is_array($ruri) && $first_lang->id == $this->languages->lang_id() && $ruri[1] == $first_lang->label)
                {
                    header("HTTP/1.1 301 Moved Permanently");
                    header('Location: '.$this->config->root_url.'/'.implode('/',array_slice($ruri, 2)));
                    exit();
                }

                foreach($languages as &$l)
                {
                    if($first_lang->id !== $l->id) // основному языку не нужна метка
                    {
                        $l->url = $l->label . ($ruri?'/'.implode('/',array_slice($ruri, $as)):'');
                    }else
                    {
                        $l->url = ($ruri?'/'.implode('/',array_slice($ruri, $as)):'');
                    }
                }
            }

			// Все валюты
			$this->currencies = $this->money->get_currencies(array('enabled'=>1));
	
			// Выбор текущей валюты
			if($currency_id = $this->request->get('currency_id', 'integer'))
			{
				$_SESSION['currency_id'] = $currency_id;
				header("Location: ".$this->request->url(array('currency_id'=>null)));
			}
			
			// Берем валюту из сессии
			if(isset($_SESSION['currency_id']))
				$this->currency = $this->money->get_currency($_SESSION['currency_id']);
			// Или первую из списка
			else
				$this->currency = reset($this->currencies);
	
			// Пользователь, если залогинен
			if(isset($_SESSION['user_id']))
			{
				$u = $this->users->get_user(intval($_SESSION['user_id']));
				if($u && $u->enabled)
				{
					$this->user = $u;
					$this->group = $this->users->get_group($this->user->group_id);
				
				}
			}
            
            if(isset($_SESSION['compared_products'])){
                $compare_products = count($_SESSION['compared_products']);
            }
            else $compare_products = 0;
                $this->design->assign('compare_products',	$compare_products);

            if(!empty($_COOKIE['wishlist_products']))
            {
                $wishlist_products = explode(',', $_COOKIE['wishlist_products']);
                $this->design->assign('wishlist_products',	$wishlist_products);
            } 

			// Текущая страница (если есть)
			$subdir = substr(dirname(dirname(__FILE__)), strlen($_SERVER['DOCUMENT_ROOT']));
			$page_url = trim(substr($_SERVER['REQUEST_URI'], strlen($subdir)),"/");
			if(strpos($page_url, '?') !== false)
				$page_url = substr($page_url, 0, strpos($page_url, '?'));
            
            if(!empty($languages) && !empty($first_lang))
            {
                $strlen = $first_lang->id == $this->language->id ? "" : $first_lang->label;
                $page_url = trim(substr($page_url, strlen($strlen)),"/");
            }
			
            $this->design->assign('language', $this->language);
            $this->design->assign('languages', $languages);
            $this->design->assign('lang', $this->translations);
            
			$this->page = $this->pages->get_page((string)$page_url);
			$this->design->assign('page', $this->page);		
			
			// Передаем в дизайн то, что может понадобиться в нем
			$this->design->assign('currencies',	$this->currencies);
			$this->design->assign('currency',	$this->currency);
			$this->design->assign('user',       $this->user);
			$this->design->assign('group',      $this->group);
			
			$this->design->assign('config',		$this->config);
			$this->design->assign('settings',	$this->settings);

			// Настраиваем плагины для смарти
			$this->design->smarty->registerPlugin("function", "get_posts",					array($this, 'get_posts_plugin'));
            $this->design->smarty->registerPlugin("function", "get_banner",                 array($this, 'get_banner_plugin'));
			$this->design->smarty->registerPlugin("function", "get_brands",					array($this, 'get_brands_plugin'));
			$this->design->smarty->registerPlugin("function", "get_captcha",                array($this, 'get_captcha_plugin'));
			$this->design->smarty->registerPlugin("function", "get_articles",               array($this, 'get_articles_plugin'));
			$this->design->smarty->registerPlugin("function", "get_products",               array($this, 'get_products_plugin'));
			$this->design->smarty->registerPlugin("function", "get_new_products",			array($this, 'get_new_products_plugin'));
			$this->design->smarty->registerPlugin("function", "get_browsed_products",		array($this, 'get_browsed_products'));
			$this->design->smarty->registerPlugin("function", "get_featured_products",		array($this, 'get_featured_products_plugin'));
			$this->design->smarty->registerPlugin("function", "get_discounted_products",	array($this, 'get_discounted_products_plugin'));
			
			// Marks
            $this->design->smarty->registerPlugin("function", "get_is_new_products", array($this, 'get_is_new_products_plugin'));
            $this->design->smarty->registerPlugin("function", "get_is_hit_products", array($this, 'get_is_hit_products_plugin'));
            
            // функции для работы с js 
            $this->design->smarty->registerPlugin('block', 'js',        array($this, 'add_javascript_block'));
            $this->design->smarty->registerPlugin('function', 'unset_js',        array($this, 'unset_javascript_function'));
            $this->design->smarty->registerPlugin('function', 'javascript',      array($this, 'print_javascript'));

            // функции для работы с css 
            $this->design->smarty->registerPlugin('block', 'css',        array($this, 'add_stylesheet_block'));
            $this->design->smarty->registerPlugin('function', 'unset_css',        array($this, 'unset_stylesheet_function'));
            $this->design->smarty->registerPlugin('function', 'stylesheet',       array($this, 'print_stylesheet'));
            
            // Last comments
            $this->design->smarty->registerPlugin("function", "get_comments",   array($this, 'get_comments_plugin'));

            // Рекомендуемые категории товаров
            $this->design->smarty->registerPlugin("function", "get_featured_categories", array($this, 'get_featured_categories_plugin'));
         
		}
	}
		
	/**
	 *
	 * Отображение
	 *
	 */
	function fetch()
	{
		return false;
	}
	
	/**
	 *
	 * Плагины для смарти
	 *
	 */
	
	// Рекомендуемые категории товаров
	public function get_featured_categories_plugin($params, $smarty)
	{
		if(!isset($params['featured']))
			$params['featured'] = 1;
			$params['visible'] = 1;
		if(!empty($params['var']))
			$smarty->assign($params['var'], $this->categories->get_categories_tree($params));
	}  
	
	public function get_captcha_plugin($params, $smarty) {
        if(isset($params['var'])) {
            $number = 0;
            unset($_SESSION[$params['var']]);
            $total = rand(10,50);
            $secret = rand(1,10);
            $result[] = $total - $secret;
            $result[] = $total;
            $_SESSION[$params['var']] = $secret;
            $smarty->assign($params['var'], $result);
        } else {
            return false;
        }
    }   
    
    public function get_banner_plugin($params, $smarty){
        if(!isset($params['group']) || empty($params['group'])) {
            return false;
        }

		@$articles_category = $this->design->smarty->getTemplateVars('articles_category');
        @$category = $this->design->smarty->getTemplateVars('category');
        @$brand = $this->design->smarty->getTemplateVars('brand');
        @$page = $this->design->smarty->getTemplateVars('page');
        
        $show_filter_array = array('categories'=>$category->id,'brands'=>$brand->id,'articles_categories'=>$articles_category->id,'pages'=>$page->id);
        $banner = $this->banners->get_banner($params['group'], true, $show_filter_array);
        if(!empty($banner)) {
            if($items = $this->banners->get_banners_images(array('banner_id'=>$banner->id, 'visible'=>1))) {
                $banner->items = $items;
            }
            $smarty->assign($params['var'], $banner);
        }
	}
   
	public function get_posts_plugin($params, $smarty)
	{
		if(!isset($params['visible']))
			$params['visible'] = 1;
		if(!empty($params['var']))
			$posts = $this->blog->get_posts($params);
            if(empty($posts))
                return false;
            
            foreach ($posts as &$post) {
                $post->comments = count($this->comments->get_comments(array('type'=>'blog', 'object_id'=>$post->id, 'approved'=>1)));
            }
            $smarty->assign($params['var'], $posts);
		
	}
	
	public function get_articles_plugin($params, $smarty)
	{
		if(!isset($params['visible']))
			$params['visible'] = 1;
		if(!empty($params['var']))
			$posts = $this->articles->get_articles($params);
            if(empty($posts))
                return false;
            
            foreach ($posts as &$post) {
                $post->comments = count($this->comments->get_comments(array('type'=>'article', 'object_id'=>$post->id, 'approved'=>1)));
				$post->category = $this->articles_categories->get_articles_category(intval($post->category_id));
            }
            $smarty->assign($params['var'], $posts);
	}
	
	public function get_comments_plugin($params, $smarty)
    {
		if(!isset($params['approved']))
			$params['approved'] = 1;
		if(!empty($params['var']))
			$smarty->assign($params['var'], $this->comments->get_comments($params));
    }
    
    public function get_brands_plugin($params, $smarty)
	{
		if(!empty($params['var']))
			$smarty->assign($params['var'], $this->brands->get_brands($params));
	}
	
	public function get_products_plugin($params, $smarty)
	{
		if(!empty($params['var']))
		{
			foreach($this->products->get_products($params) as $p){
				$products[$p->id] = $p;
				$products[$p->id]->variants = [];
				$products[$p->id]->images = [];
			}

			if(!empty($products))
			{
				// id выбраных товаров
				$products_ids = array_keys($products);
				
				// Выбираем варианты товаров
				$variants = $this->variants->get_variants(array('product_id'=>$products_ids, 'in_stock'=>true));

				// Для каждого варианта
				foreach($variants as &$variant)
				{
					// добавляем вариант в соответствующий товар
					$products[$variant->product_id]->variants[] = $variant;
				}

				// Выбираем изображения товаров
				$images = $this->products->get_images(array('product_id'=>$products_ids));
				foreach($images as $image)
					$products[$image->product_id]->images[] = $image;

				foreach($products as &$product)
				{
					if(isset($product->variants[0]))
						$product->variant = $product->variants[0];
					if(isset($product->images[0]))
						$product->image = $product->images[0];
					
					if (!empty($product->sale_to) && strtotime($product->sale_to) <= time()) {
                        $product->sale_to = null;                    
                        if (isset($product->variant) && $product->variant->compare_price) {
                            $product->variant->price = $product->variant->compare_price;
                            $product->variant->compare_price = 0;
                            $v = new stdClass();
                            $v->price = $product->variant->price;
                            $v->compare_price = 0;
                            $this->variants->update_variant($product->variant->id, $v);
                        }
                    }
				}
			}

			$smarty->assign($params['var'], $products);

		}
	}
	
	public function get_browsed_products($params, $smarty)
	{
		if(!empty($_COOKIE['browsed_products']))
		{	
			$browsed_products_ids = explode(',', $_COOKIE['browsed_products']);
			$browsed_products_ids = array_reverse($browsed_products_ids);
			if(isset($params['limit']))
				$browsed_products_ids = array_slice($browsed_products_ids, 0, $params['limit']);

			$products = array();
			foreach($this->products->get_products(array('id'=>$browsed_products_ids)) as $p){
				$products[$p->id] = $p;
				$products[$p->id]->variants = [];
				$products[$p->id]->images = [];
			}
				
			$variants = $this->variants->get_variants(array('product_id'=>$browsed_products_ids, 'in_stock'=>true));
			foreach($variants as &$variant)
			{
				$products[$variant->product_id]->variants[] = $variant;
			}
			
			$browsed_products_images = $this->products->get_images(array('product_id'=>$browsed_products_ids));
			foreach($browsed_products_images as $browsed_product_image)
				if(isset($products[$browsed_product_image->product_id]))
					$products[$browsed_product_image->product_id]->images[] = $browsed_product_image;
			
			foreach($browsed_products_ids as $id)
			{	
				if(isset($products[$id]))
				{
					if(isset($products[$id]->images[0]))
						$products[$id]->image = $products[$id]->images[0];
					if(isset($product[$id]->variants[0]))
						$product[$id]->variant = $products[$id]->variants[0];
					$result[] = $products[$id];
                    
				}
			}
			$smarty->assign($params['var'], $result);
		}
	}
	
	public function get_featured_products_plugin($params, $smarty)
	{
		if(!isset($params['visible']))
			$params['visible'] = 1;
		$params['featured'] = 1;
		if(!empty($params['var']))
		{
			foreach($this->products->get_products($params) as $p){
				$products[$p->id] = $p;
				$products[$p->id]->variants = [];
				$products[$p->id]->images = [];
			}
			
			if(!empty($products))
			{
				// id выбраных товаров
				$products_ids = array_keys($products);
				
				// Выбираем варианты товаров
				$variants = $this->variants->get_variants(array('product_id'=>$products_ids, 'in_stock'=>true));
				
				// Для каждого варианта
				foreach($variants as &$variant)
				{
					// добавляем вариант в соответствующий товар
					$products[$variant->product_id]->variants[] = $variant;
				}
				
				// Выбираем изображения товаров
				$images = $this->products->get_images(array('product_id'=>$products_ids));
				foreach($images as $image)
					$products[$image->product_id]->images[] = $image;
	
				foreach($products as &$product)
				{
					if(isset($product->variants[0]))
						$product->variant = $product->variants[0];
					if(isset($product->images[0]))
						$product->image = $product->images[0];
                    
                    if (!empty($product->sale_to) && strtotime($product->sale_to) <= time()) {
                        $product->sale_to = null;                    
                        if (isset($product->variant) && $product->variant->compare_price) {
                            $product->variant->price = $product->variant->compare_price;
                            $product->variant->compare_price = 0;
                            $v = new stdClass();
                            $v->price = $product->variant->price;
                            $v->compare_price = 0;
                            $this->variants->update_variant($product->variant->id, $v);
                        }
                    }
				}				
			}

			$smarty->assign($params['var'], $products);
			
		}
	}
	
	public function get_is_new_products_plugin($params, $smarty)
	{
	    if(!isset($params['visible']))
	        $params['visible'] = 1;
	    $params['is_new'] = 1;
	    if(!empty($params['var']))
	    {
	        foreach($this->products->get_products($params) as $p){
				$products[$p->id] = $p;
				$products[$p->id]->variants = [];
				$products[$p->id]->images = [];
			}
	 
	        if(!empty($products))
	        {
	            // id выбраных товаров
	            $products_ids = array_keys($products);
				
	            // Выбираем варианты товаров
	            $variants = $this->variants->get_variants(array('product_id'=>$products_ids, 'in_stock'=>true));
	             
	            // Для каждого варианта
	            foreach($variants as &$variant)
	            {
	                // добавляем вариант в соответствующий товар
	                $products[$variant->product_id]->variants[] = $variant;
	            }
	             
	            // Выбираем изображения товаров
	            $images = $this->products->get_images(array('product_id'=>$products_ids));
	            foreach($images as $image)
	                $products[$image->product_id]->images[] = $image;
	 
	            foreach($products as &$product)
	            {
	            	//количество отзывов
					$product->comments_count = $this->comments->count_comments(array('object_id'=>$product->id, 'type'=>'product', 'approved'=>1));
	                if(isset($product->variants[0]))
	                    $product->variant = $product->variants[0];
	                if(isset($product->images[0]))
	                    $product->image = $product->images[0];
						
					if (!empty($product->sale_to) && strtotime($product->sale_to) <= time()) {
                        $product->sale_to = null;                    
                        if (isset($product->variant) && $product->variant->compare_price) {
                            $product->variant->price = $product->variant->compare_price;
                            $product->variant->compare_price = 0;
                            $v = new stdClass();
                            $v->price = $product->variant->price;
                            $v->compare_price = 0;
                            $this->variants->update_variant($product->variant->id, $v);
                        }
                    }	
	            }     

	            // Cвойства товара
	            $features = $this->features->get_product_options($products_ids);
				foreach($features as &$feature) {
					$products[$feature->product_id]->features[] = $feature;
				}

	            // Категории товара
				$categories = $this->categories->get_product_categories($products_ids);
					foreach($categories as $cat)
					$products[$cat->product_id]->category = $this->categories->get_category((int)$cat->category_id);
		
	        }
	 
	        $smarty->assign($params['var'], $products);
	         
	    }
	}

	public function get_is_hit_products_plugin($params, $smarty)
	{
	    if(!isset($params['visible']))
	        $params['visible'] = 1;
	    $params['is_hit'] = 1;
	    if(!empty($params['var']))
	    {
	        foreach($this->products->get_products($params) as $p){
				$products[$p->id] = $p;
				$products[$p->id]->variants = [];
				$products[$p->id]->images = [];
			}
	 
	        if(!empty($products))
	        {
	            // id выбраных товаров
	            $products_ids = array_keys($products);
				
	            // Выбираем варианты товаров
	            $variants = $this->variants->get_variants(array('product_id'=>$products_ids, 'in_stock'=>true));
	             
	            // Для каждого варианта
	            foreach($variants as &$variant)
	            {
	                // добавляем вариант в соответствующий товар
	                $products[$variant->product_id]->variants[] = $variant;
	            }
	             
	            // Выбираем изображения товаров
	            $images = $this->products->get_images(array('product_id'=>$products_ids));
	            foreach($images as $image)
	                $products[$image->product_id]->images[] = $image;
	 
	            foreach($products as &$product)
	            {
	            	//количество отзывов
					$product->comments_count = $this->comments->count_comments(array('object_id'=>$product->id, 'type'=>'product', 'approved'=>1));
	                if(isset($product->variants[0]))
	                    $product->variant = $product->variants[0];
	                if(isset($product->images[0]))
	                    $product->image = $product->images[0];
						
					if (!empty($product->sale_to) && strtotime($product->sale_to) <= time()) {
                        $product->sale_to = null;                    
                        if (isset($product->variant) && $product->variant->compare_price) {
                            $product->variant->price = $product->variant->compare_price;
                            $product->variant->compare_price = 0;
                            $v = new stdClass();
                            $v->price = $product->variant->price;
                            $v->compare_price = 0;
                            $this->variants->update_variant($product->variant->id, $v);
                        }
                    }	
	            }     

	            // Cвойства товара
	            $features = $this->features->get_product_options($products_ids);
				foreach($features as &$feature) {
					$products[$feature->product_id]->features[] = $feature;
				}

	            // Категории товара
				$categories = $this->categories->get_product_categories($products_ids);
					foreach($categories as $cat)
					$products[$cat->product_id]->category = $this->categories->get_category((int)$cat->category_id);
				   
	        }
	 
	        $smarty->assign($params['var'], $products);
	         
	    }
	}
		
	public function get_new_products_plugin($params, $smarty)
	{
		if(!isset($params['visible']))
			$params['visible'] = 1;
		if(!isset($params['sort']))
			$params['sort'] = 'created';
		if(!empty($params['var']))
		{
			foreach($this->products->get_products($params) as $p){
				$products[$p->id] = $p;
				$products[$p->id]->variants = [];
				$products[$p->id]->images = [];
			}

			if(!empty($products))
			{
				// id выбраных товаров
				$products_ids = array_keys($products);
				
				// Выбираем варианты товаров
				$variants = $this->variants->get_variants(array('product_id'=>$products_ids, 'in_stock'=>true));
				
				// Для каждого варианта
				foreach($variants as &$variant)
				{
					// добавляем вариант в соответствующий товар
					$products[$variant->product_id]->variants[] = $variant;
				}
				
				// Выбираем изображения товаров
				$images = $this->products->get_images(array('product_id'=>$products_ids));
				foreach($images as $image)
					$products[$image->product_id]->images[] = $image;
	
				foreach($products as &$product)
				{
					if(isset($product->variants[0]))
						$product->variant = $product->variants[0];
					if(isset($product->images[0]))
						$product->image = $product->images[0];
                    
                    if (!empty($product->sale_to) && strtotime($product->sale_to) <= time()) {
                        $product->sale_to = null;                    
                        if (isset($product->variant) && $product->variant->compare_price) {
                            $product->variant->price = $product->variant->compare_price;
                            $product->variant->compare_price = 0;
                            $v = new stdClass();
                            $v->price = $product->variant->price;
                            $v->compare_price = 0;
                            $this->variants->update_variant($product->variant->id, $v);
                        }
                    }
				}				
			}

			$smarty->assign($params['var'], $products);
			
		}
	}
	
	public function get_discounted_products_plugin($params, $smarty)
	{
		if(!isset($params['visible']))
			$params['visible'] = 1;
		$params['discounted'] = 1;
		if(!empty($params['var']))
		{
			foreach($this->products->get_products($params) as $p){
				$products[$p->id] = $p;
				$products[$p->id]->variants = [];
				$products[$p->id]->images = [];
			}

			if(!empty($products))
			{
				// id выбраных товаров
				$products_ids = array_keys($products);
				
				// Выбираем варианты товаров
				$variants = $this->variants->get_variants(array('product_id'=>$products_ids, 'in_stock'=>true));
				
				// Для каждого варианта
				foreach($variants as &$variant)
				{
					// добавляем вариант в соответствующий товар
					$products[$variant->product_id]->variants[] = $variant;
				}
				
				// Выбираем изображения товаров
				$images = $this->products->get_images(array('product_id'=>$products_ids));
				foreach($images as $image)
					$products[$image->product_id]->images[] = $image;
	
				foreach($products as &$product)
				{
					if(isset($product->variants[0]))
						$product->variant = $product->variants[0];
					if(isset($product->images[0]))
						$product->image = $product->images[0];
                    
                    if (!empty($product->sale_to) && strtotime($product->sale_to) <= time()) {
                        $product->sale_to = null;                    
                        if (isset($product->variant) && $product->variant->compare_price) {
                            $product->variant->price = $product->variant->compare_price;
                            $product->variant->compare_price = 0;
                            $v = new stdClass();
                            $v->price = $product->variant->price;
                            $v->compare_price = 0;
                            $this->variants->update_variant($product->variant->id, $v);
                        }
                    }
				}				
			}

			$smarty->assign($params['var'], $products);
			
		}
	}
	
	/*
    * Функции для работа с файлами javascript
    * Регистрация  js фал(а|ов) или кода
    */
	
    public function add_javascript_block($params, $content, $smarty, &$repeat)
    {
        if(!isset($params['id']) || $repeat || (empty($content)) && empty($params['include']))
            return false;


        if(!isset($params['priority']))
            $params['priority'] = 10;
            
        if(!empty($params['include']))
            $this->js->add_files($params['id'], $params['include'], $params['priority']);
        
        if(!empty($content))
            $this->js->add_code($params['id'], $content, $params['priority']);
            


        if(!empty($params['render']))
        {
            if(!isset($params['minify']))
                $params['minify'] = null;    
            
            if(!isset($params['combine']))
                $params['combine'] = true;
            
            return $this->js->render($params['id'], $params['minify'], $params['combine']);
        }
    }  
	
    /*
    * Отмена регистрации js фал(а|ов) или кода
    */
	
    public function unset_javascript_function($params, $smarty)
    {
        if(!isset($params['id']))
            return false;


        $this->js->unplug($params['id']);
    }
	
    /*
    * Вывод упакованого js файла 
    */
	
    public function print_javascript($params)
    {
        if(!isset($params['id']))
            $params['id'] = null;
            
        if(!isset($params['combine']))
            $params['combine'] = true;
        
        if(!isset($params['minify']))
            $params['minify'] = null;
    
        return $this->js->render($params['id'], $params['minify'], $params['combine']);
    }    
    
    /*
    * Функции для работа с файлами стилей
    * Регистрация  css фал(а|ов) или кода
    */
	
    public function add_stylesheet_block($params, $content, $smarty, &$repeat)
    {
        if(!isset($params['id']) || $repeat || (empty($content)) && empty($params['include']))
            return false;


        if(!isset($params['priority']))
            $params['priority'] = 10;
        
        if(!isset($params['less']))
            $params['less'] = false;
            
        if(!empty($params['include']))
            $this->css->add_files($params['id'], $params['include'], $params['priority'], $params['less']);
        
        if(!empty($content))
            $this->css->add_code($params['id'], $content, $params['priority'], $params['less']);


        if(!empty($params['render']))
        {
            if(!isset($params['minify']))
                $params['minify'] = null;    
            
            if(!isset($params['combine']))
                $params['combine'] = true;
            
            return $this->css->render($params['id'], $params['minify'], $params['combine']);
        }
    } 
	
    /*
    * Отмена регистрации css фал(а|ов) или кода
    */
	
    public function unset_stylesheet_function($params, $smarty)
    {
        if(!isset($params['id']))
            return false;


        $this->css->unplug($params['id']);
    }
	
    /*
    * Вывод упакованого css файла 
    */
	
    public function print_stylesheet($params)
    {
        if(!isset($params['id']))
            $params['id'] = null;
            
        if(!isset($params['combine']))
            $params['combine'] = true;
        
        if(!isset($params['minify']))
            $params['minify'] = null;
    
        return $this->css->render($params['id'], $params['minify'], $params['combine']);
    }
}