;<? exit(); ?>

[database]

;Сервер базы данных
db_server = "localhost";

;Пользователь базы данных
db_user = "admin";

;Пароль к базе
db_password = "admin";

;Имя базы
db_name = "turboshop";

;Префикс для таблиц
db_prefix = "t_";

;Кодировка базы данных
db_charset = "UTF8";

;Режим SQL
db_sql_mode = "NO_ZERO_DATE,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION";

;Смещение часового пояса
;db_timezone = "+02:00";

[php]

error_reporting = E_ALL;
php_charset = UTF8;
php_locale_collate = ru_RU;
php_locale_ctype = ru_RU;
php_locale_monetary = ru_RU;
php_locale_numeric = ru_RU;
php_locale_time = ru_RU;
;php_timezone = Europe/Kiev;
debug_mode = false;

logfile = admin/log/log.txt;

[debug]

debug = false;

[minify]

minify_js = false; сжимать javascript (true=да, false=нет)
minify_css = false; сжимать css (true=да, false=нет)
minify_gzip_level = 0; уровень сжатия (gzip) от 0 до 9
minify_cache_dir = cache/minify/; папка для кеширования

sanitize_output = false;

[smarty]

smarty_compile_check = true;
smarty_caching = false;
smarty_cache_lifetime = 0;
smarty_debugging = false;
smarty_html_minify = false;
smarty_security = true;
debug_translation = false;
 
[images]

;Использовать imagemagick для обработки изображений (вместо gd)
use_imagick = false;

;Директория оригиналов изображений
original_images_dir = files/originals/;

;Директория миниатюр
resized_images_dir = files/products/;

;Изображения категорий
categories_images_dir = files/categories/;
resized_category_images_dir = files/categories/preview/;

;Изображения брендов
brands_images_dir = files/brands/;
resized_brands_images_dir = files/brands/preview/;

;Файл изображения с водяным знаком
watermark_file = turbo/files/watermark/watermark.png;

;Изображения баннеров
banners_images_dir = files/slides/;
resized_banners_images_dir = files/slides/preview/;

;Изображения записей блога
posts_images_dir = files/posts/;
resized_posts_images_dir = files/posts/preview/;

;Изображения записей cтатьи
articles_images_dir = files/articles/;
resized_articles_images_dir = files/articles/preview/;

[files]

;Директория файлов
cms_files_dir = files/files/;