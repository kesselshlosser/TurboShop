{if $order->paid}
    {$subject = "`$btr->email_order` `$order->id` `$btr->email_paid`" scope=global}
{else}
    {$subject = "`$btr->email_new_order` `$order->id`" scope=global}
{/if}

<h1 style="font-weight:normal;font-family:arial;">
	<a href="{$config->root_url}/turbo/index.php?module=OrderAdmin&id={$order->id}">{$btr->email_order|escape}{$order->id}</a>
	{$btr->email_for_sum|escape} {$order->total_price|convert:$main_currency->id}&nbsp;{$main_currency->sign}
	{if $order->paid == 1}{$btr->email_paid|escape}{else}{$btr->email_not_paid|escape}{/if},
	{if $order->status == 0}{$btr->email_status_waiting|escape}{elseif $order->status == 1}{$btr->email_status_in|escape}{elseif $order->status == 2}{$btr->email_status_completed|escape}{/if}	
</h1>
<table cellpadding="6" cellspacing="0" style="border-collapse: collapse;">
	<tr>
		<td style="padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$btr->email_status|escape}
		</td>
		<td style="padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{if $order->status == 0}
				{$btr->email_status_waiting|escape}      
			{elseif $order->status == 1}
				{$btr->email_status_in|escape}
			{elseif $order->status == 2}
				{$btr->email_status_completed|escape}
			{/if}
		</td>
	</tr>
	<tr>
		<td style="padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$btr->email_payment_status|escape}
		</td>
		<td style="padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{if $order->paid == 1}
			<font color="green">{$btr->email_paid|escape}</font>
			{else}
				{$btr->email_not_paid|escape}
			{/if}
		</td>
	</tr>
	{if $order->name}
	<tr>
		<td style="padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$btr->email_order_name|escape}
		</td>
		<td style="padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->name|escape}
			{if $user}(<a href="{$config->root_url}/turbo/index.php?module=UserAdmin&id={$user->id}">{$btr->email_order_user|escape}</a>){/if}
		</td>
	</tr>
	{/if}
	{if $order->email}
	<tr>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$btr->email_order_email|escape}
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->email|escape}
		</td>
	</tr>
	{/if}
	{if $order->phone}
	<tr>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$btr->email_order_phone|escape}
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->phone|escape}
		</td>
	</tr>
	{/if}
	{if $order->address}
	<tr>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$btr->email_order_address|escape}
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->address|escape}
		</td>
	</tr>
	{/if}
	{if $order->comment}
	<tr>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$btr->email_order_comment|escape}
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->comment|escape|nl2br}
		</td>
	</tr>
	{/if}
	<tr>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$btr->general_date|escape}
		</td>
		<td style="padding:6px; width:170; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->date|date} {$order->date|time}
		</td>
	</tr>
</table>

<h1 style="font-weight:normal;font-family:arial;">{$btr->email_order_purchases|escape}:</h1>

<table cellpadding="6" cellspacing="0" style="border-collapse: collapse;">

	{foreach $purchases as $purchase}
	<tr>
		<td align="center" style="padding:6px; width:100; padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$img_flag=0}
			{$image_array=","|explode:$purchase->variant->images_ids}
				{foreach $purchase->product->images as $image}
					{if $image->id|in_array:$image_array}
						{if $img_flag==0}{$image_toshow=$image}{/if}
						{$img_flag=1}
					{/if}
				{/foreach}
			{if $img_flag ne 0}
				<a href="products/{$purchase->product->url}">
					<img src="{$image_toshow->filename|resize:50:50}" alt="{$purchase->product->name|escape}">
				</a>
			{else}
				{$image = $purchase->product->images|first}
				{if $image}
					<a href="products/{$purchase->product->url}">
						<img src="{$image->filename|resize:50:50}" alt="{$purchase->product->name|escape}">
					</a>
				{/if}
			{/if}
		</td>
		<td style="padding:6px; width:250; padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			<a href="{$config->root_url}/products/{$purchase->product->url}">{$purchase->product_name}</a>
			{if $purchase->variant->color}{$purchase->variant->color|escape} / {/if}{$purchase->variant->name|escape}
		</td>
		<td align=right style="padding:6px; text-align:right; width:150; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$purchase->amount} {$settings->units} &times; {$purchase->price|convert:$main_currency->id}&nbsp;{$main_currency->sign}
		</td>
	</tr>
	{/foreach}
	
	{if $order->discount}
	<tr>
		<td style="padding:6px; width:100; padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;"></td>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$btr->email_order_discount|escape}
		</td>
		<td align=right style="padding:6px; text-align:right; width:170; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->discount}&nbsp;%
		</td>
	</tr>
	{/if}

	{if $order->coupon_discount>0}
	<tr>
		<td style="padding:6px; width:100; padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;"></td>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$btr->email_order_coupon|escape} {$order->coupon_code}
		</td>
		<td align=right style="padding:6px; text-align:right; width:170; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			&minus;{$order->coupon_discount}&nbsp;{$currency->sign}
		</td>
	</tr>
	{/if}
	
	{if $order->weight>0}
	<tr>
		<td style="padding:6px; width:100; padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;"></td>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$btr->general_weight|escape}
		</td>
		<td align=right style="padding:6px; text-align:right; width:170; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->weight}  {$settings->weight_units}
		</td>
	</tr>
	{/if}

	{if $delivery && !$order->separate_delivery}
	<tr>
		<td style="padding:6px; width:100; padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;"></td>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$delivery->name}
		</td>
		<td align="right" style="padding:6px; text-align:right; width:170; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->delivery_price|convert:$main_currency->id}&nbsp;{$main_currency->sign}
		</td>
	</tr>
	{/if}
	
	<tr>
		<td style="padding:6px; width:100; padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;"></td>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;font-weight:bold;">
			{$btr->email_order_total|escape}
		</td>
		<td align="right" style="padding:6px; text-align:right; width:170; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;font-weight:bold;">
			{$order->total_price|convert:$main_currency->id}&nbsp;{$main_currency->sign}
		</td>
	</tr>
</table>