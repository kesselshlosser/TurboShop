<?php

require_once('api/Turbo.php');
$turbo = new Turbo();

header("Content-type: text/xml; charset=UTF-8");
print (pack('CCC', 0xef, 0xbb, 0xbf));
// Заголовок
print
"<?xml version='1.0' encoding='UTF-8'?>
<!DOCTYPE yml_catalog SYSTEM 'shops.dtd'>
<yml_catalog date='".date('Y-m-d H:i')."'>
<shop>
<name>".$turbo->settings->site_name."</name>
<company>".$turbo->settings->company_name."</company>
<url>".$turbo->config->root_url."</url>
";

// Валюты
$currencies = $turbo->money->get_currencies(array('enabled'=>1));
$main_currency = reset($currencies);
print "<currencies>
";
foreach($currencies as $c)
if($c->enabled)
print "<currency id='".$c->code."' rate='".$c->rate_to/$c->rate_from*$main_currency->rate_from/$main_currency->rate_to."'/>
";
print "</currencies>
";

// Категории
$categories = $turbo->categories->get_categories();
print "<categories>
";
foreach($categories as $c)
{
print "<category id='$c->id'";
if($c->parent_id>0)
	print " parentId='$c->parent_id'";
print ">".htmlspecialchars($c->name)."</category>
";
}
print "</categories>
";

$stock_filter = $turbo->settings->export_export_not_in_stock ? '' : ' AND (v.stock >0 OR v.stock is NULL) ';
$price_filter = $turbo->settings->export_no_export_without_price ? ' AND v.price >0 ' : '';

// Товары
$turbo->db->query("SET SQL_BIG_SELECTS=1");
// Свойства товаров
$features = array();
$turbo->db->query("SELECT f.id as feature_id, f.name, po.value, po.product_id FROM t_options po LEFT JOIN t_features f ON f.id=po.feature_id ORDER BY f.position");
foreach($turbo->db->results() as $f)
  if(!empty($f->name)) 
    $features[$f->product_id][$f->name] = $f->value;
// Товары
$turbo->db->query("SELECT v.price, v.id as variant_id, p.name as product_name, b.name as vendor, v.name as variant_name, v.position as variant_position, v.sku, p.id as product_id, p.url, p.annotation, p.body, pc.category_id, i.filename as image
					FROM __variants v LEFT JOIN __products p ON v.product_id=p.id
					
					LEFT JOIN __products_categories pc ON p.id = pc.product_id AND pc.position=(SELECT MIN(position) FROM __products_categories WHERE product_id=p.id LIMIT 1)	
					LEFT JOIN __images i ON p.id = i.product_id AND i.position=(SELECT MIN(position) FROM __images WHERE product_id=p.id LIMIT 1)	
                    LEFT JOIN __brands b on (b.id = p.brand_id)
					WHERE p.visible AND p.to_export $stock_filter $price_filter GROUP BY v.id ORDER BY p.id, v.position ");
print "<offers>
";
 
$currency_code = reset($currencies)->code;

// В цикле мы используем не results(), a result(), то есть выбираем из базы товары по одному,
// так они нам одновременно не нужны - мы всё равно сразу же отправляем товар на вывод.
// Таким образом используется памяти только под один товар
$prev_product_id = null;
while($p = $turbo->db->result())
{
$variant_url = '';
if ($prev_product_id === $p->product_id)
	$variant_url = '?variant='.$p->variant_id;
$prev_product_id = $p->product_id;

$price = round($turbo->money->convert($p->price, $main_currency->id, false),2);
print
"
<offer id='$p->variant_id' available='true'>
<url>".$turbo->config->root_url.'/products/'.$p->url.$variant_url."</url>";
print "
<price>$price</price>
<currencyId>".$currency_code."</currencyId>
<categoryId>".$p->category_id."</categoryId>
";

if($p->image)
print "<picture>".$turbo->design->resize_modifier($p->image, 200, 200)."</picture>
";

print "<store>".($turbo->settings->export_available_for_retail_store ? 'true' : 'false')."</store>
<pickup>".($turbo->settings->export_available_for_reservation ? 'true' : 'false')."</pickup>
<delivery>true</delivery>
<vendor>".htmlspecialchars($p->vendor)."</vendor>
".($p->sku ? '<vendorCode>'.$p->sku.'</vendorCode>' : '')."
";

print "<name>".htmlspecialchars($p->product_name).($p->variant_name?' '.htmlspecialchars($p->variant_name):'')."</name>
<description>".htmlspecialchars(strip_tags(($turbo->settings->export_short_description ? $p->body : $p->annotation)))."</description>
".($turbo->settings->export_sales_notes ? "<sales_notes>".htmlspecialchars(strip_tags($turbo->settings->export_sales_notes))."</sales_notes>" : "")."
";

print "<manufacturer_warranty>".($turbo->settings->export_has_manufacturer_warranty ? 'true' : 'false')."</manufacturer_warranty>
<seller_warranty>".($turbo->settings->export_has_seller_warranty ? 'true' : 'false')."</seller_warranty>
";
 
if(isset($features[$p->product_id]))
foreach($features[$p->product_id] as $k=>$v)
print "<param name='".htmlspecialchars($k)."'>".htmlspecialchars($v)."</param>
";
 
print "</offer>
";
}

print "</offers>
";
print "</shop>
</yml_catalog>
";