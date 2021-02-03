<?php

chdir('../../');
require_once 'api/Turbo.php';
require_once 'autoload.php';
require_once 'YandexMoneyCallbackHandler.php';


$turbo  = new Turbo();
$handler = new YandexMoneyCallbackHandler($turbo);

$order_id   = $turbo->request->post('customerNumber');
$invoice_id = $turbo->request->post('invoiceId');

$action = $turbo->request->get('action');

if ($action == 'notify') {
    $handler->processNotification();
} else {
    $handler->processReturnUrl();
}

