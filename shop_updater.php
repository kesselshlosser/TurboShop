<?php
/**
 * Turbo CMS Update
 * 
 * powered by TurboShop
 *
 * Файлик для внесения изменений в базу, необходимых для модуля "ЧПУ-фильтр расширенный"
 *
 */
 
require_once('api/Turbo.php');
$turbo = new Turbo();

/**
 * Добавляем необходимые поля в таблицы t_options и t_features
 */
$turbo->db->query("ALTER TABLE __options ADD translit VARCHAR(255) NOT NULL DEFAULT '' AFTER value");
$turbo->db->query("ALTER TABLE __features ADD url VARCHAR(255) NOT NULL DEFAULT ''");
print_r('Поля добавлены');

/**
 * Проставляем урлы для свойств
 */
$turbo->db->query("SELECT id, name FROM __features ORDER BY id");
foreach($turbo->db->results() as $f){
    $turbo->features->update_feature($f->id,array('url'=>$turbo->features->translit($f->name)));
}
print_r('<br /><br />Урлы проставлены');

/**
 * Транслитерируем значения свойств
 */
$turbo->db->query("SELECT * FROM __options");
foreach($turbo->db->results() as $o){
    $turbo->features->update_option($o->product_id,$o->feature_id,$o->value);
}
print_r('<br /><br />Свойства транслитерированы');

//Автоудалялка
//@unlink($_SERVER['SCRIPT_FILENAME']);