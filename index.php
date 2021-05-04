<?PHP

/**
 * Turbo CMS
 *
 * @author	Turbo CMS
 * @link	https://turbo-cms.com
 *
 */

// Засекаем время
$time_start = microtime(true);

session_start();

require_once('view/IndexView.php');

$view = new IndexView();

/* ini_set('error_reporting', E_ALL);
ini_set('display_startup_errors', 1); */
ini_set('display_errors', 0);

if(isset($_GET['logout']))
{
    header('WWW-Authenticate: Basic realm="Turbo CMS"');
    header('HTTP/1.0 401 Unauthorized');
	unset($_SESSION['admin']);
}

if ($view->config->sanitize_output) {

	function sanitize_output($buffer) {
		$buffer = str_replace('  ', ' ', $buffer);
		$buffer = str_replace(array("\r\n", "\r", "\n", "\t", '  ', '   ', '    '), '', $buffer);
		
		$buffer = preg_replace("/<!--(.*?)-->/sm", "", $buffer);
		$buffer = preg_replace("#\s+#", " ", $buffer);
		$buffer = str_replace("> <", "><", $buffer);
		$buffer = str_replace(" >", ">", $buffer);
		$buffer = str_replace("< ", "<", $buffer);
		return $buffer;
	}
}

// Если все хорошо
if(($res = $view->fetch()) !== false)
{
	// Выводим результат
	header("Content-type: text/html; charset=UTF-8");	
	if ($view->config->sanitize_output) {
		
		print sanitize_output($res);
	}	
	else 
	{
		print $res;
	}

	// Сохраняем последнюю просмотренную страницу в переменной $_SESSION['last_visited_page']
	if(empty($_SESSION['last_visited_page']) || empty($_SESSION['current_page']) || $_SERVER['REQUEST_URI'] !== $_SESSION['current_page'])
	{
		if(!empty($_SESSION['current_page']) && !empty($_SESSION['last_visited_page']) && $_SESSION['last_visited_page'] !== $_SESSION['current_page'])
			$_SESSION['last_visited_page'] = $_SESSION['current_page'];
		$_SESSION['current_page'] = $_SERVER['REQUEST_URI'];
	}		
}
else 
{ 
	// Иначе страница об ошибке
	header("http/1.0 404 not found");
	
	// Подменим переменную GET, чтобы вывести страницу 404
	$_GET['page_url'] = '404';
	$_GET['module'] = 'PageView';
	print $view->fetch();   
}

// Отладочная информация
if ($view->config->debug) {
    print "<!--\r\n";
    $exec_time = round(microtime(true)-$time_start, 5);
    print "page generation time: " . $exec_time . "s\r\n";
    if (function_exists('memory_get_peak_usage')) {
        print "memory peak usage: " . (round(memory_get_peak_usage() / 1048576 * 100) / 100) . " mb\r\n";
    }
    print "-->";
}