{if $label->id}
	{$meta_title = $label->name scope=global}
{else}
	{$meta_title =$btr->orders_new_label scope=global}
{/if}

<div class="row">
    <div class="col-lg-6 col-md-6">
        <div class="heading_page">
        {if $label->id}
            {$btr->orders_label|escape}: {$label->name|escape}
        {else}
            {$btr->orders_new_label|escape}
        {/if}  
        </div>
    </div>
   <div class="col-lg-4 col-md-3 text-xs-right float-xs-right"></div>
</div>

{if $message_success}
<div class="row">
    <div class="col-lg-12 col-md-12 col-sm-12">
        <div class="boxed boxed_success">
            <div class="heading_box">
                {if $message_success == 'added'}
                    {$btr->orders_added_label|escape}
                {elseif $message_success == 'updated'}
                    {$btr->orders_updated_label|escape}
                {/if}
                {if $smarty.get.return}
                <a class="btn btn_return float-xs-right" href="{$smarty.get.return}">
                    {include file='svg_icon.tpl' svgId='return'}
                    <span>{$btr->general_back|escape}</span>
                </a>
                {/if}
            </div>
        </div>
    </div>
</div>
{/if}

<div class="boxed fn_toggle_wrap">
   <div class="toggle_body_wrap on fn_card">
      <form class="fn_form_list" id="product" enctype="multipart/form-data" method="post">
         <input type="hidden" name="session_id" value="{$smarty.session.id}">
         <div class="turbo_list turbo_list_order">
            <div class="fn_labels_list turbo_list_body sortable fn_sort_list">
               <div class="fn_row turbo_list_body_item">
                  <div class="turbo_list_row fn_sort_item">
                     <div class="turbo_list_boding turbo_list_order_stg_lbl_name">
                        <input class="form-control" name="name" type="text" value="{$label->name|escape}"/> 
                        <input name=id type="hidden" value="{$label->id|escape}"/> 
                     </div>
                     <div class="turbo_list_boding turbo_list_order_stg_sts_label">
                        <input id="color_input" name="color" class="turbo_inp" type="hidden" value="{$label->color|escape}" />
                        <span data-hint="#{$label->color}" id="color_icon" class="fn_color label_color_item hint-bottom-middle-t-info-s-small-mobile  hint-anim" style="background-color:#{$label->color};"></span>
                     </div>
                  </div>
               </div>
            </div>
         </div>
         <div class="row">
            <div class="col-lg-12 col-md-12 mt-1">
               <button type="submit" value="labels" class="btn btn_small btn_green float-md-right">
                  {include file='svg_icon.tpl' svgId='checked'}
                  <span>{$btr->general_apply|escape}</span>
               </button>
            </div>
         </div>
      </form>
   </div>
</div>

{* On document load *}
{literal}
<link rel="stylesheet" media="screen" type="text/css" href="design/js/colorpicker/css/colorpicker.css" />
<script type="text/javascript" src="design/js/colorpicker/js/colorpicker.js"></script>
<script>
   $(function() {
      $('#color_icon, #color_link').ColorPicker({
         color: $('#color_input').val(),
         onShow: function (colpkr) {
            $(colpkr).fadeIn(500);
            return false;
         },
         onHide: function (colpkr) {
            $(colpkr).fadeOut(500);
            return false;
         },
         onChange: function (hsb, hex, rgb) {
            $('#color_icon').css('backgroundColor', '#' + hex);
            $('#color_input').val(hex);
            $('#color_input').ColorPickerHide();
         }
      });
   });
</script>
{/literal}