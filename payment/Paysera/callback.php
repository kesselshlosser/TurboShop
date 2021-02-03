<?php

/**
 * Turbo CMS
 *
 * @copyright 	Turbo CMS
 * @link 		https://turbo-cms.com
 * @author 		Turbo CMS
 *
 * К этому скрипту обращается Paysera в процессе оплаты
 *
 */
 
// Работаем в корневой директории
require_once('WebToPay.php');
chdir ('../../');
require_once('api/Turbo.php');

$turbo = new Turbo();
$order_id = $_GET['order_id'];
////////////////////////////////////////////////
// Выберем заказ из базы
////////////////////////////////////////////////
$order = $turbo->orders->get_order(intval($order_id));
if(empty($order))
	die('Оплачиваемый заказ не найден');

// Нельзя оплатить уже оплаченный заказ  
if($order->paid)
	die('Этот заказ уже оплачен');

////////////////////////////////////////////////
// Выбираем из базы соответствующий метод оплаты
////////////////////////////////////////////////
$method = $turbo->payment->get_payment_method(intval($order->payment_method_id));
if(empty($method))
	die("Неизвестный метод оплаты");
 
$settings = unserialize($method->settings);
       

$response = WebToPay::checkResponse($_GET, array(
		'projectid' => $settings['paysera_project_id'],
		'sign_password' => $settings['paysera_password']));

if ($response['type'] !== 'macro') {
	die('Only macro payment callbacks are accepted');
}

$test_mode = $response['test'];
$order_id = $response['orderid'];
$amount = $response['amount'];
$currency = $response['currency'];


////////////////////////////////////
// Проверка суммы платежа
////////////////////////////////////
       
// Сумма заказа у нас в магазине
$order_amount = $turbo->money->convert($order->total_price, $method->currency_id, false);
       
// Должна быть равна переданной сумме
if(round($order_amount*100) != $amount || $amount<=0)
	die("Неверная сумма оплаты");
     
// Запишем
if(!$pre_request)
{
	// Установим статус оплачен
	$turbo->orders->update_order(intval($order->id), array('paid'=>1));

	// Спишем товары  
	$turbo->orders->close(intval($order->id));
}

if(!$pre_request)
{
	$turbo->notify->email_order_user(intval($order->id));
	$turbo->notify->email_order_admin(intval($order->id));
}

die("OK");
