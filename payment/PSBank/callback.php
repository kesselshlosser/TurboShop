<?php

/**
 * Turbo CMS
 *
 * @copyright 	Turbo CMS
 * @link 		https://turbo-cms.com
 * @author 		Turbo CMS
 *
 * К этому скрипту обращается Промсвязьбанк в процессе оплаты
 *
 */

// Работаем в корневой директории
chdir ('../../');
require_once('api/Turbo.php');

$turbo = new Turbo();
$order_id = intval($_POST['ORDER']) - 1000000;

////////////////////////////////////////////////
// Выберем заказ из базы
////////////////////////////////////////////////
$order = $turbo->orders->get_order(intval($order_id));
if(empty($order))
	stop('Оплачиваемый заказ не найден');

// Нельзя оплатить уже оплаченный заказ  
if($order->paid)
	stop('Этот заказ уже оплачен');

////////////////////////////////////////////////
// Выбираем из базы соответствующий метод оплаты
////////////////////////////////////////////////
$method = $turbo->payment->get_payment_method(intval($order->payment_method_id));
if(empty($method))
	stop("Неизвестный метод оплаты");
 
$settings = unserialize($method->settings);


////////////////////////////////////////////////
// Проверка контрольной подписи
////////////////////////////////////////////////
$fields = array('AMOUNT', 'CURRENCY', 'ORDER', 'MERCH_NAME', 'MERCHANT', 'TERMINAL', 'EMAIL', 'TRTYPE', 'TIMESTAMP', 'NONCE', 'BACKREF', 'RESULT', 'RC', 'RCTEXT', 'AUTHCODE', 'RRN', 'INT_REF');
$mac = '';
foreach($fields as $f)
{
	if($_POST[$f] !== '')
		$mac .= strlen($_POST[$f]).$_POST[$f];
	else
		$mac .= '-';
}
$sign = hash_hmac('sha1', $mac ,pack('H*', $settings['psbank_key']));
if(strtoupper($sign) != $_POST['P_SIGN'])
	stop('Контрольная подпись неверна');

////////////////////////////////////
// Проверка суммы платежа
////////////////////////////////////
       
// Сумма заказа у нас в магазине
$order_amount = $turbo->money->convert($order->total_price, $method->currency_id, false);
       
// Должна быть равна переданной сумме
if($order_amount != $_POST['AMOUNT'] || $_POST['AMOUNT']<=0)
	stop("Неверная сумма оплаты");

// Проверка успешности операции
if($_POST['RESULT'] != 0)
	stop("RESULT != 0, ".$_POST['RCTEXT']);

// Установим статус оплачен
$turbo->orders->update_order(intval($order->id), array('paid'=>1));

// Спишем товары  
$turbo->orders->close(intval($order->id));


$turbo->notify->email_order_user(intval($order->id));
$turbo->notify->email_order_admin(intval($order->id));


stop("OK");

function stop($message)
{
	print($message);
	die();
}

