<?php
ini_set("display_errors",1);
error_reporting(E_ALL);
 

// Работаем в корневой директории
chdir ('../../');
require_once('api/Turbo.php');
require "wse-php-master/soapme.php";

$turbo = new Turbo();
 
$order = $turbo->orders->get_order(intval($_GET["order"]));
if(empty($order))
	die('Оплачиваемый заказ не найден');
  
$method = $turbo->payment->get_payment_method(intval($order->payment_method_id));
if(empty($method))
	die("Неизвестный метод оплаты");
	
$settings = unserialize($method->settings);
$payment_currency = $turbo->money->get_currency(intval($method->currency_id));

////////////////////////////////////////////////
// Проверка 
////////////////////////////////////////////////
 
		$ulog = $settings['sberbank_login'];
		$upas = $settings['sberbank_password'];
		$wsse_header = new WsseAuthHeader($ulog, $upas);
		$client = new SoapClient('https://securepayments.sberbank.ru/payment/webservices/merchant-ws?wsdl', array("trace" => 1, "exception" => 0));
		$client->__setSoapHeaders(array($wsse_header));	
		$res = $client->getOrderStatus(array("orderId"=>$_GET["orderId"])); 

		//print_r($res);

// Если указана ошибка оплаты
if ($res->errorCode > 0)
	die("Ошибка оплаты");

if ($res->orderNumber != $order->id)
	die("Ошибка оплаты. " . $order->actionCodeDescription);

// Нельзя оплатить уже оплаченный заказ  
if($order->paid)
	header('Location: '.$turbo->config->root_url . '/order/'.$order->url);

if($res->amount != 100*round($turbo->money->convert($order->total_price, $method->currency_id, false), 2) || $res->amount<=0)
	die("incorrect price");

// Установим статус оплачен
$turbo->orders->update_order(intval($order->id), array('paid'=>1));

// Отправим уведомление на email
$turbo->notify->email_order_user(intval($order->id));
$turbo->notify->email_order_admin(intval($order->id));

// Спишем товары  
$turbo->orders->close(intval($order->id));

header('Location: '.$turbo->config->root_url . '/order/'.$order->url);

exit();
