{* Single blog post page *}

{* Canonical page address *}
{$canonical="/blog/{$post->url}" scope=global}

<!-- Breadcrumb /-->
{$level = 1}
<nav class="mt-4" aria-label="breadcrumb">
	<ol itemscope itemtype="https://schema.org/BreadcrumbList" class="breadcrumb bg-light">
		<li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem" class="breadcrumb-item">
			<a itemprop="item" href="{$lang_link}"><span itemprop="name">{$lang->home}</span></a>
			<meta itemprop="position" content="{$level++}" />
		</li>
		<li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem" class="breadcrumb-item">
			<a itemprop="item" href="{$lang_link}blog"><span itemprop="name">{$lang->index_blog}</span></a>
			<meta itemprop="position" content="{$level++}" />
		</li>
		<li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem" class="breadcrumb-item active" aria-current="page">
		<a itemprop="item" href="{$lang_link}blog/{$post->url}"><span itemprop="name">{$post->name|escape}</span></a>
			<meta itemprop="position" content="{$level++}" />
		</li>
	</ol>
</nav>
<!-- Breadcrumb #End /-->

<div itemscope itemtype="http://schema.org/BlogPosting">
	<div itemprop="publisher" itemscope itemtype="https://schema.org/Organization">
	<meta itemprop="name" content="{$settings->site_name|escape}">
	<span itemprop="logo" itemscope itemtype="https://schema.org/ImageObject">
		<meta itemprop="image url" content="{$config->root_url}/design/{$settings->theme|escape}/images/logo.png" />
		<meta property="url" content="{$config->root_url}/" />
	</span>
	</div>
	<meta itemprop="dateModified" content="{$post->date}">
	<meta itemprop="author" content="{$settings->site_name|escape}">
	<meta itemscope itemprop="mainEntityOfPage" itemType="https://schema.org/WebPage" itemid="/blog/{$post->url}"/>
	<link itemprop="url" href="{$lang_link}blog/{$post->url}" />
	
	<!-- Page title -->
	<h1 data-post="{$post->id}" itemprop="headline name" class="mt-4">{$post->name|escape}</h1>
	<hr>
	<!-- Date/Time -->
	<p>
		<span class="btn text-muted"><i class="far fa-calendar"></i><span itemprop="datePublished" content="{$post->date}" class="badge card-link">{$post->date|date}</span></span>
		<span class="btn text-muted"><i class="far fa-eye"></i><span class="badge card-link">{$post->views}</span></span>
		<span class="btn text-muted"><i class="far fa-comment"></i><span class="badge card-link">{$comments|count}</span></span>
	</p>
	<hr>
	{if $post->image}
	<!-- Preview Image -->
	<div class="card mb-4">
		<img itemprop="image" class="img-fluid rounded" src="{$post->image|resize_posts:700:700}" alt="{$post->name|escape}">
	</div>
	<hr>
	<!-- Post Content -->
	{/if}
	<article class="block__description content entry-content" itemprop="articleBody">
		{if $post->text|stristr:"h2" || $post->text|stristr:"h3" || $post->text|stristr:"h4"}
		<div class="table-of-contents open">
			<div class="table-of-contents__header"><span class="js-table-of-contents-hide table-of-contents__hide">{$lang->table_of_contents} <i class="icon-action fa fa-chevron-down"></i></span></div>
			<ol data-toc=".content" data-toc-headings="h2,h3,h4" class="table-of-contents__list js-table-of-contents-list"></ol>
		</div>
		{/if}
		{$post->text}
	</article>
	<div class="tags">
		{foreach $tags as $tag}
			<a class="mr-2" href="{$lang_link}blog/?keyword={$tag}">#{$tag}</a>
		{/foreach}
	</div>
	<span class="btn-group vote my-4">
		<a class="btn vote__button--plus" href="ajax/blog.rate.php?id={$post->id}&rate=up"><i class="fa fa-chevron-up" aria-hidden="true"></i></a>
		{if $post->rate>0}
			<span class="btn vote__value pos">{$post->rate}</span>
		{elseif $post->rate == 0}
			<span class="btn text-muted vote__value">{$post->rate}</span>
		{else}
			<span class="btn vote__value neg">{$post->rate}</span>
		{/if}
		<a class="btn vote__button--minus" href="ajax/blog.rate.php?id={$post->id}&rate=down"><i class="fa fa-chevron-down" aria-hidden="true"></i></a>
	</span>
</div>
{if $prev_post || $next_post}
<hr>
<div class="row">
	<div class="col-lg-6 col-sm-6 col-6 text-left">
		{if $prev_post}
		<a href="{$lang_link}blog/{$prev_post->url}">???&nbsp;{$prev_post->name}</a>
		{/if}
	</div>
	<div class="col-lg-6 col-sm-6 col-6 text-right">
		{if $next_post}
		<a href="{$lang_link}blog/{$next_post->url}">{$next_post->name}&nbsp;???</a>
		{/if}
	</div>
</div>
<hr>
{/if}

{* Comments *}
{if $settings->comments_tree_blog == "on"}
	{include file='comments_tree_blog.tpl'}
{else}
	{include file='comments_blog.tpl'}
{/if}