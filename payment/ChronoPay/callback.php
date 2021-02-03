<?php
if ($_SERVER['REMOTE_ADDR'] !== '185.30.16.166') {
	header('HTTP/1.0 401 Unauthorized');
	echo "Error 401";
	return;
}

chdir ('../../');
require_once('api/Turbo.php');

$turbo = new Turbo();

$order = $turbo->orders->get_order(intval($_POST['order_id']));
$method = $turbo->payment->get_payment_method(intval($order->payment_method_id));

$settings = unserialize($method->settings);

$sign = md5(
	trim($settings['chronopay_sharedSec']).
	$_POST['customer_id'].
	$_POST['transaction_id'].
	$_POST['transaction_type'].
	$_POST['total']
);

if($sign == $_POST['sign']) {
	$turbo->orders->update_order(intval($order->id), array('paid'=>1));

	$turbo->orders->close(intval($order->id));
	$turbo->notify->email_order_user(intval($order->id));
	$turbo->notify->email_order_admin(intval($order->id));
}
