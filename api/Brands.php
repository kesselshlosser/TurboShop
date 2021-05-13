<?php

/**
 * Turbo CMS
 *
 * @author	Turbo CMS
 * @link	https://turbo-cms.com
 *
 */

require_once('Turbo.php');

class Brands extends Turbo
{
	/*
	*
	* Функция возвращает массив брендов, удовлетворяющих фильтру
	* @param $filter
	*
	*/
	public function get_brands($filter = array())
	{
		$category_id_filter = '';
		$visible_filter = '';
		$in_stock_filter = '';

		if(isset($filter['in_stock']))
			$in_stock_filter = $this->db->placehold('AND (SELECT count(*)>0 FROM __variants pv WHERE pv.product_id=p.id AND pv.price>0 AND (pv.stock IS NULL OR pv.stock>0) LIMIT 1) = ?', intval($filter['in_stock']));

		if(isset($filter['visible']))
			$visible_filter = $this->db->placehold('AND p.visible=?', intval($filter['visible']));
		
		if(!empty($filter['category_id'])){
			$category_id_filter = $this->db->placehold("LEFT JOIN __products p ON p.brand_id=b.id LEFT JOIN __products_categories pc ON p.id = pc.product_id WHERE pc.category_id in(?@) $visible_filter", (array)$filter['category_id']);
            if(!empty($filter['features']))
    			foreach($filter['features'] as $feature=>$value)
    				$category_id_filter .= $this->db->placehold(' AND p.id in (SELECT product_id FROM __options WHERE feature_id=? AND value in(?@) ) ', $feature, (array)$value);
            if(!empty($filter['brand_id']))
                $category_id_filter .= $this->db->placehold(" OR b.id in(?@)", (array)$filter['brand_id']);
        }
        
        $lang_sql = $this->languages->get_query(array('object'=>'brand'));
		
		// Выбираем все бренды
		$query = $this->db->placehold("SELECT DISTINCT b.id, b.name, b.url, b.visible, b.meta_title, b.meta_keywords, b.meta_description, b.description, b.image, b.last_modified, ".$lang_sql->fields."
								 		FROM __brands b ".$lang_sql->join." $category_id_filter ORDER BY b.name");
		$this->db->query($query);

		return $this->db->results();
	}

	/*
	*
	* Функция возвращает бренд по его id или url
	* (в зависимости от типа аргумента, int - id, string - url)
	* @param $id id или url поста
	*
	*/
	public function get_brand($id)
	{
		if(is_int($id))			
			$filter = $this->db->placehold('b.id = ?', $id);
		else
			$filter = $this->db->placehold('b.url = ?', $id);
        
        $lang_sql = $this->languages->get_query(array('object'=>'brand'));
        
		$query = "SELECT b.id, b.name, b.url, b.visible, b.meta_title, b.meta_keywords, b.meta_description, b.description, b.image, b.last_modified, ".$lang_sql->fields."
								 FROM __brands b ".$lang_sql->join." WHERE $filter LIMIT 1";
		$this->db->query($query);
		return $this->db->result();
	}

	/*
	*
	* Добавление бренда
	* @param $brand
	*
	*/
	public function add_brand($brand)
	{
		$brand = (object)$brand;
        $brand->url = preg_replace("/[\s]+/ui", '', $brand->url);
        $brand->url = strtolower(preg_replace("/[^0-9a-z]+/ui", '', $brand->url));
        if(empty($brand->url)) {
            $brand->url = $this->translit($brand->name);
        }
        while($this->get_brand((string)$brand->url)) {
            if(preg_match('/(.+)([0-9]+)$/', $brand->url, $parts)) {
                $brand->url = $parts[1].''.($parts[2]+1);
            } else {
                $brand->url = $brand->url.'2';
            }
        }

	    // Проверяем есть ли мультиязычность и забираем описания для перевода
	    $result = $this->languages->get_description($brand, 'brand');
        if(!empty($result->data))$brand = $result->data;

		$this->db->query("INSERT INTO __brands SET ?%", $brand);

		$id = $this->db->insert_id();

        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)){
            $this->languages->action_description($id, $result->description, 'brand');
        }
        return $id;
	}

	/*
	*
	* Обновление бренда(ов)
	* @param $brand
	*
	*/		
    public function update_brand($id, $brand)
	{
	    $brand = (object)$brand;

	    // Проверяем есть ли мультиязычность и забираем описания для перевода
	    $result = $this->languages->get_description($brand, 'brand');
        if(!empty($result->data))$brand = $result->data;

		$query = $this->db->placehold("UPDATE __brands SET `last_modified`=NOW(), ?% WHERE id=? LIMIT 1", $brand, intval($id));
		$this->db->query($query);

        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)){
            $this->languages->action_description($id, $result->description, 'brand', $this->languages->lang_id());
        }

		return $id;
	}
	
	/*
	*
	* Удаление бренда
	* @param $id
	*
	*/	
	public function delete_brand($id)
	{
		if(!empty($id))
		{
			$this->delete_image($id);	
			$query = $this->db->placehold("DELETE FROM __brands WHERE id=? LIMIT 1", $id);
			$this->db->query($query);		
			$query = $this->db->placehold("UPDATE __products SET brand_id=NULL WHERE brand_id=?", $id);
			$this->db->query($query);
            $this->db->query("DELETE FROM __lang_brands WHERE brand_id=?", $id);
		}
	}
	
	/*
	*
	* Удаление изображения бренда
	* @param $id
	*
	*/
	public function delete_image($brand_id)
	{
		$query = $this->db->placehold("SELECT image FROM __brands WHERE id=?", intval($brand_id));
		$this->db->query($query);
		$filename = $this->db->result('image');
		if(!empty($filename))
		{
			$query = $this->db->placehold("UPDATE __brands SET image=NULL WHERE id=?", $brand_id);
			$this->db->query($query);
			$query = $this->db->placehold("SELECT count(*) as count FROM __brands WHERE image=? LIMIT 1", $filename);
			$this->db->query($query);
			$count = $this->db->result('count');
			if($count == 0)
            {			
                $file = pathinfo($filename, PATHINFO_FILENAME);
                $ext = pathinfo($filename, PATHINFO_EXTENSION);
				$webp = 'webp';
                
                // Удалить все ресайзы
                $rezised_images = glob($this->config->root_dir.$this->config->resized_brands_images_dir.$file.".*x*.".$ext);
                if(is_array($rezised_images))
                foreach (glob($this->config->root_dir.$this->config->resized_brands_images_dir.$file.".*x*.".$ext) as $f)
                    @unlink($f);
				
				$rezised_images = glob($this->config->root_dir.$this->config->resized_brands_images_dir.$file.".*x*.".$webp);
                if(is_array($rezised_images))
                foreach (glob($this->config->root_dir.$this->config->resized_brands_images_dir.$file.".*x*.".$webp) as $f)
                    @unlink($f);

                @unlink($this->config->root_dir.$this->config->brands_images_dir.$filename);		
            }
		}
	}
	
	public function translit($text){
        $ru = explode('-', "А-а-Б-б-В-в-Ґ-ґ-Г-г-Д-д-Е-е-Ё-ё-Є-є-Ж-ж-З-з-И-и-І-і-Ї-ї-Й-й-К-к-Л-л-М-м-Н-н-О-о-П-п-Р-р-С-с-Т-т-У-у-Ф-ф-Х-х-Ц-ц-Ч-ч-Ш-ш-Щ-щ-Ъ-ъ-Ы-ы-Ь-ь-Э-э-Ю-ю-Я-я"); 
		$en = explode('-', "A-a-B-b-V-v-G-g-G-g-D-d-E-e-E-e-E-e-ZH-zh-Z-z-I-i-I-i-I-i-J-j-K-k-L-l-M-m-N-n-O-o-P-p-R-r-S-s-T-t-U-u-F-f-H-h-TS-ts-CH-ch-SH-sh-SCH-sch---Y-y---E-e-YU-yu-YA-ya");

	 	$res = str_replace($ru, $en, $text);
		$res = preg_replace("/[\s-_]+/ui", '', $res);
		$res = preg_replace('/[^\p{L}\p{Nd}\d-]/ui', '', $res);
	 	$res = strtolower($res);
	    return $res; 
    }
}