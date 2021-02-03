<?php

/**
 * Turbo CMS
 *
 * @author	Turbo CMS
 * @link	https://turbo-cms.com
 *
 */

require_once('Turbo.php');

class Pages extends Turbo
{

	/*
	*
	* Функция возвращает страницу по ее id или url (в зависимости от типа)
	* @param $id id или url страницы
	*
	*/
	public function get_page($id)
	{
		if(gettype($id) == 'string')
			$where = $this->db->placehold(' WHERE url=? ', $id);
		else
			$where = $this->db->placehold(' WHERE id=? ', intval($id));
        
        $lang_sql = $this->languages->get_query(array('object'=>'page'));
		
		$query = "SELECT p.id, p.url, p.header, p.name, p.meta_title, p.meta_description, p.meta_keywords, p.body, p.menu_id, p.parent_id, p.position, p.visible, p.last_modified, ".$lang_sql->fields."
		          FROM __pages p ".$lang_sql->join." $where LIMIT 1";

		$this->db->query($query);
		return $this->db->result();
	}
	
	/*
	*
	* Функция возвращает массив страниц, удовлетворяющих фильтру
	* @param $filter
	*
	*/
	public function get_pages($filter = array())
	{	
		$menu_filter = '';
		$visible_filter = '';
        $keyword_filter = '';
		$pages = array();
		
		$lang_id  = $this->languages->lang_id();
        $px = ($lang_id ? 'l' : 'p');

		if(isset($filter['menu_id']))
			$menu_filter = $this->db->placehold('AND menu_id in (?@)', (array)$filter['menu_id']);

		if(isset($filter['visible']))
			$visible_filter = $this->db->placehold('AND visible = ?', intval($filter['visible']));
        
        $lang_sql = $this->languages->get_query(array('object'=>'page'));
        
        if(isset($filter['keyword']))
		{
			$keywords = explode(' ', $filter['keyword']);
			foreach($keywords as $keyword)
				$keyword_filter .= $this->db->placehold('AND ('.$px.'.name LIKE "%'.$this->db->escape(trim($keyword)).'%" OR '.$px.'.meta_keywords LIKE "%'.$this->db->escape(trim($keyword)).'%") ');
		}
		
		$query = "SELECT p.id, p.url, p.header, p.name, p.meta_title, p.meta_description, p.meta_keywords, p.body, p.menu_id, p.position, p.visible, p.last_modified, ".$lang_sql->fields."
		          FROM __pages p ".$lang_sql->join." WHERE 1 $menu_filter $keyword_filter $visible_filter ORDER BY position";
	
		$this->db->query($query);
		
		foreach($this->db->results() as $page)
			$pages[$page->id] = $page;
			
		return $pages;
	}

	/*
	*
	* Создание страницы
	*
	*/	
	public function add_page($page)
	{	
		$page = (object)$page;

	    // Проверяем есть ли мультиязычность и забираем описания для перевода
	    $result = $this->languages->get_description($page, 'page');
        if(!empty($result->data))$page = $result->data;
        
        $query = $this->db->placehold('INSERT INTO __pages SET ?%', $page);
		if(!$this->db->query($query))
			return false;

		$id = $this->db->insert_id();
        
        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)){
            $this->languages->action_description($id, $result->description, 'page');
        }
        
		$this->db->query("UPDATE __pages SET position=id WHERE id=?", $id);	
		return $id;
	}
	
	/*
	*
	* Обновить страницу
	*
	*/
	public function update_page($id, $page)
	{	
		
        $page = (object)$page;

	    // Проверяем есть ли мультиязычность и забираем описания для перевода
	    $result = $this->languages->get_description($page, 'page');
        if(!empty($result->data))$page = $result->data;
        
        $query = $this->db->placehold('UPDATE __pages SET `last_modified`=NOW(), ?% WHERE id in (?@)', $page, (array)$id);
		if(!$this->db->query($query))
			return false;
        
        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)){
            $this->languages->action_description($id, $result->description, 'page', $this->languages->lang_id());
        }
        
		return $id;
	}
	
	/*
	*
	* Удалить страницу
	*
	*/	
	public function delete_page($id)
	{
		if(!empty($id))
		{
			$query = $this->db->placehold("DELETE FROM __pages WHERE id=? LIMIT 1", intval($id));
			if($this->db->query($query))
                $this->db->query("DELETE FROM __lang_pages WHERE page_id=?", intval($id));
				return true;
		}
		return false;
	}	
	
	/*
	*
	* Функция возвращает массив меню
	*
	*/
	public function get_menus()
	{
		$menus = array();
		$query = "SELECT * FROM __menu ORDER BY position";
		$this->db->query($query);
		foreach($this->db->results() as $menu)
			$menus[$menu->id] = $menu;
		return $menus;
	}
   
   /*
	*
	* Обновить список меню
	*
	*/
	private function init_menu()
	{
		$this->menus = array();
		// Выбираем из базы меню
		$query = "SELECT id, name, position FROM __menu ORDER BY position";
		$this->db->query($query);
		
		$results = $this->db->results();
		
		foreach($results as $c)
		{
			$this->menus[$c->id] = $c;
		}
		
		$this->menu = reset($this->menus);

	}

	/*
	*
	* Создание меню
	*
	*/	
	public function add_menu($menu)
	{	
		$query = $this->db->placehold('INSERT INTO __menu SET ?%', $menu);
		if(!$this->db->query($query))
			return false;

		$id = $this->db->insert_id();
		$this->db->query("UPDATE __menu SET position=id WHERE id=?", $id);	
		$this->init_menu();
		return $id;
	}
	
	/*
	*
	* Обновить меню
	*
	*/
	public function update_menu($id, $menu)
	{	
		$query = $this->db->placehold('UPDATE __menu SET ?% WHERE id in (?@)', $menu, (array)$id);
		if(!$this->db->query($query))
			return false;
		$this->init_menu();
		return $id;
	}
	
	/*
	*
	* Удалить меню
	*
	*/	
	public function delete_menu($id)
	{
		if(!empty($id))
		{
			$query = $this->db->placehold("DELETE FROM __menu WHERE id=? LIMIT 1", intval($id));
			if($this->db->query($query))
				return true;
			$this->init_menu();
		}
		return false;
	}
	
	/*
	*
	* Функция возвращает меню по id
	* @param $id
	*
	*/
	public function get_menu($menu_id)
	{	
		$query = $this->db->placehold("SELECT * FROM __menu WHERE id=? LIMIT 1", intval($menu_id));
		$this->db->query($query);
		return $this->db->result();
	}
   
   // Список указателей на меню в дереве меню (ключ = id меню)
	private $all_pages;
	// Дерево меню
	private $pages_tree;

	// Функция возвращает дерево меню
	public function get_pages_tree($filter=array())
	{
		//if(!isset($this->pages_tree))
        unset($this->init_pages,$this->all_pages);
			$this->init_pages($filter);
			
		return $this->pages_tree;
	}
   
    // Инициализация меню, после которой меню будем выбирать из локальной переменной
	private function init_pages($filter=array())
	{
		$menu_id = '';
		$is_visible = '';
        //print_r($filter);
        if(isset($filter['visible']) && isset($filter['menu_id'])){
            $query = $this->db->placehold('SELECT COUNT(*) FROM __pages WHERE id=? AND visible=1', intval($filter['menu_id']));
            $this->db->query($query);
            if(!$this->db->result('COUNT(*)'))
                return false;
        }
            
		if(isset($filter['menu_id']))
			$menu_id = $this->db->placehold(" AND menu_id=? ", intval($filter['menu_id']));
		
		if(isset($filter['visible']))
            $is_visible = ' AND visible =1 ';
			
		// Дерево меню
		$tree = new stdClass();
		$tree->subpages = array();
		
		// Указатели на узлы дерева
		$pointers = array();
		$pointers[0] = &$tree;
		$pointers[0]->path = array();
		$pointers[0]->level = 0;
		
		$lang_sql = $this->languages->get_query(array('object'=>'page'));
		
		// Выбираем все меню
		$query = $this->db->placehold("SELECT *, ".$lang_sql->fields." FROM __pages p ".$lang_sql->join." WHERE 1 $menu_id $is_visible ORDER BY p.parent_id, p.position");
		$this->db->query($query);
		$pages = $this->db->results();
				
		$finish = false;
		// Не кончаем, пока не кончатся меню, или пока ниодну из оставшихся некуда приткнуть
		while(!empty($pages)  && !$finish)
		{
			$flag = false;
			// Проходим все выбранные меню
			foreach($pages as $k=>$page)
			{
				if(isset($pointers[$page->parent_id]))
				{
					// В дерево меню (через указатель) добавляем текущую меню
					$pointers[$page->id] = $pointers[$page->parent_id]->subpages[] = $page;
					
					// Путь к текущей меню
					$curr = $pointers[$page->id];
					$pointers[$page->id]->path = array_merge((array)$pointers[$page->parent_id]->path, array($curr));
					
					// Уровень вложенности меню
					$pointers[$page->id]->level = 1+$pointers[$page->parent_id]->level;

					// Убираем использованную меню из массива меню
					unset($pages[$k]);
					$flag = true;
				}
			}
			if(!$flag) $finish = true;
		}
		
		// Для каждой меню id всех ее деток узнаем
		$ids = array_reverse(array_keys($pointers));
		foreach($ids as $id)
		{
			if($id>0)
			{
				$pointers[$id]->children[] = $id;

				if(isset($pointers[$pointers[$id]->parent_id]->children))
					$pointers[$pointers[$id]->parent_id]->children = array_merge($pointers[$id]->children, $pointers[$pointers[$id]->parent_id]->children);
				else
					$pointers[$pointers[$id]->parent_id]->children = $pointers[$id]->children;
			}
		}
		unset($pointers[0]);
		unset($ids);

		$this->pages_tree = $tree->subpages;
		$this->all_pages = $pointers;	
	}	
}
