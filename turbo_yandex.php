<?php

require_once('api/Turbo.php');
$turbo = new \Turbo();

$site_name    = $turbo->settings->site_name;
$root_url     = $turbo->config->root_url;
$company_name = $turbo->settings->company_name;
$lang         = 'ru';
$date_rss     = 'D, d M Y H:i:s O';

/***** Заголовок ******/
print <<<HEAD
<?xml version="1.0" encoding="UTF-8"?>
<rss xmlns:yandex="http://news.yandex.ru"
     xmlns:media="http://search.yahoo.com/mrss/"
     xmlns:turbo="http://turbo.yandex.ru"
     version="2.0">
    <channel>
        <turbo:cms_plugin>88AC70EEFE360CBE79E901D7CF751783</turbo:cms_plugin>
        <title>$site_name</title>
        <link>$root_url</link>
        <language>$lang</language>
HEAD;
/***** Заголовок (The End) ******/


// ----------------------Выборка товаров: ---------------------- //
$turbo->db->query("SELECT v.price, 
                           v.id as variant_id, 
                           p.name as product_name, 
                           v.name as variant_name, 
                           v.position as variant_position, 
                           p.id as product_id, 
                           p.url, 
                           p.body, 
                           pc.category_id, 
                           i.filename as image,
                           p.created,
                           c.name as cat_name
					FROM __variants v LEFT JOIN __products p ON v.product_id=p.id
					
					LEFT JOIN __products_categories pc ON p.id = pc.product_id 
					                                          AND pc.position=(SELECT MIN(position) 
					                                          FROM __products_categories 
					                                          WHERE product_id=p.id LIMIT 1)	
					LEFT JOIN __categories c ON pc.category_id = c.id
					LEFT JOIN __images i ON p.id = i.product_id 
					                            AND i.position=(SELECT MIN(position) 
					                            FROM __images 
					                            WHERE product_id=p.id 
					                            LIMIT 1)	
					WHERE p.visible 
					  AND (v.stock >0 OR v.stock is NULL) 
					  AND p.id ORDER BY p.id, v.position ");

$prev_product_id = null;
while ($product = $turbo->db->result()) {
    $variant_url = '';
    if ($prev_product_id === $product->product_id) {
        $variant_url = '?variant=' . $product->variant_id;
    }
    $prev_product_id = $product->product_id;

    // Переменные продукта для отображения в RSS:
    $p_link    = $root_url . '/products/' . $product->url . $variant_url;
    $p_date    = date($date_rss, strtotime($product->created));
    $p_text    = ($product->body !== '') ? $product->body : $product->body2;
    $p_h1      = $product->product_name;
    $p_h2      = $product->cat_name;
    $p_img_url = $turbo->design->resize_modifier($product->image, 800, 600, false);

    /***** Товары ******/
    print <<<ITEM
    <item turbo="true">
        <title>$product->product_name</title>
        <link>$p_link</link>
        <turbo:content>
            <![CDATA[<header><h1>$p_h1</h1><h2>$p_h2</h2><figure><img src="$p_img_url"/></figure></header><div>$p_text</div>]]>
        </turbo:content>
        <pubDate>$p_date</pubDate>
        <category>$product->cat_name</category>
    </item>
ITEM;
    /***** Товары (The End) ******/
}


// ----------------------Выборка категорий: ---------------------- //
$turbo->db->query("SELECT * FROM __categories c WHERE c.visible");

while ($category = $turbo->db->result()) {

    // Переменные продукта для отображения в RSS:
    $c_link = $root_url . '/catalog/' . $category->url;
    $c_date = date($date_rss);
    $c_text = ($category->annotation !== '') ? $category->annotation : $category->description;
    $c_h1   = $category->name;

    $category_content = "<header><h1>$c_h1</h1>";

    // Добавление изображения категории:
    if ($category->image) {
        $c_img_url = $turbo->design->resize_catalog_modifier($category->image, 800, 600, false, $turbo->config->resized_category_images_dir);
        $category_content .= "<figure><img src=\"$c_img_url\"/></figure>";
    }

    $category_content .= "</header><div>$c_text</div>";

    /***** Категории ******/
    print <<<ITEM
        <item turbo="true">
            <title>$category->name</title>
            <link>$c_link</link>
            <turbo:content>
                <![CDATA[$category_content]]>
            </turbo:content>
            <pubDate>$c_date</pubDate>
        </item>
ITEM;
    /***** Категории (The End) ******/
}

// ----------------------Выборка страниц: ---------------------- //
$turbo->db->query("SELECT * FROM __pages p WHERE p.visible");

while ($page = $turbo->db->result()) {

    // Переменные продукта для отображения в RSS:
    $page_link = $root_url . $page->url;
    $page_date = date($date_rss, strtotime($page->created));
    $page_text = $page->description;
    $page_h1   = $page->name;

    $page_content = "<header><h1>$page_h1</h1></header><div>$page_text</div>";

    /***** Страницы ******/
    print <<<ITEM
        <item turbo="true">
            <title>$page->name</title>
            <link>$page_link</link>
            <turbo:content>
                <![CDATA[$page_content]]>
            </turbo:content>
            <pubDate>$page_date</pubDate>
        </item>
ITEM;
    /***** Страницы (The End) ******/
}

// ----------------------Выборка брендов: ---------------------- //
$turbo->db->query("SELECT * FROM __brands b WHERE b.visible");

while ($brand = $turbo->db->result()) {

    // Переменные продукта для отображения в RSS:
    $brand_link = $root_url . '/brands/' . $brand->url;
    $brand_date = date($date_rss);
    $brand_text = ($brand->annotation !== '') ? $brand->annotation : $brand->description;
    $brand_h1   = $brand->name;

    $brand_content = "<header><h1>$brand_h1</h1></header><div>$brand_text</div>";

    /***** Бренды ******/
    print <<<ITEM
        <item turbo="true">
            <title>$brand->name</title>
            <link>$brand_link</link>
            <turbo:content>
                <![CDATA[$brand_content]]>
            </turbo:content>
            <pubDate>$brand_date</pubDate>
        </item>
ITEM;
    /***** Бренды (The End) ******/
}

// ----------------------Выборка блога: ---------------------- //
$turbo->db->query("SELECT * FROM __blog b WHERE b.visible");

while ($blog = $turbo->db->result()) {

    // Переменные блога для отображения в RSS:
    $blog_link = $root_url . '/blog/' . $blog->url;
    $blog_date = date($date_rss, strtotime($blog->date));
    $blog_text = ($blog->annotation !== '') ? $blog->annotation : $blog->description;
    $blog_h1   = $blog->name;
    $blog_img_url = $turbo->design->resize_posts_modifier($blog->image, 800, 600, false);

    /***** Блог ******/
    print <<<ITEM
        <item turbo="true">
            <title>$blog->name</title>
            <link>$blog_link</link>
            <turbo:content>
                <![CDATA[<header><h1>$blog_h1</h1><figure><img src="$blog_img_url"/></figure></header><div>$blog_text</div>]]>
            </turbo:content>
            <pubDate>$blog_date</pubDate>
        </item>
ITEM;
    /***** Блог (The End) ******/
}

// ----------------------Выборка категорий статей: ---------------------- //
$turbo->db->query("SELECT * FROM __articles_categories c WHERE c.visible");

while ($category = $turbo->db->result()) {

    // Переменные продукта для отображения в RSS:
    $c_link = $root_url . '/articles/' . $category->url;
    $c_date = date($date_rss);
    $c_text = ($category->annotation !== '') ? $category->annotation : $category->description;
    $c_h1   = $category->name;

    $category_content = "<header><h1>$c_h1</h1>";

    // Добавление изображения категории:
    if ($category->image) {
        $c_img_url = $turbo->design->resize_catalog_modifier($category->image, 800, 600, false, $turbo->config->resized_category_images_dir);
        $category_content .= "<figure><img src=\"$c_img_url\"/></figure>";
    }

    $category_content .= "</header><div>$c_text</div>";

    /***** Категории ******/
    print <<<ITEM
        <item turbo="true">
            <title>$category->name</title>
            <link>$c_link</link>
            <turbo:content>
                <![CDATA[$category_content]]>
            </turbo:content>
            <pubDate>$c_date</pubDate>
        </item>
ITEM;
    /***** Категории (The End) ******/
}

// ----------------------Выборка статей: ---------------------- //
$turbo->db->query("SELECT * FROM __articles a WHERE a.visible");

while ($articles = $turbo->db->result()) {

    // Переменные статьи для отображения в RSS:
    $articles_link = $root_url . '/article/' . $articles->url;
    $articles_date = date($date_rss, strtotime($articles->date));
    $articlestext = ($articles->annotation !== '') ? $articles->annotation : $articles->description;
    $articles_h1   = $articles->name;
    $articles_img_url = $turbo->design->resize_articles_modifier($articles->image, 800, 600, false, $turbo->config->resized_articles_images_dir);

    /***** Блог ******/
    print <<<ITEM
        <item turbo="true">
            <title>$articles->name</title>
            <link>$articles_link</link>
            <turbo:content>
                <![CDATA[<header><h1>$articles_h1</h1><figure><img src="$articles_img_url"/></figure></header><div>$articles_text</div>]]>
            </turbo:content>
            <pubDate>$articles_date</pubDate>
        </item>
ITEM;
    /***** Блог (The End) ******/
}

print <<<END
    </channel>
</rss>
END;

die;
?>