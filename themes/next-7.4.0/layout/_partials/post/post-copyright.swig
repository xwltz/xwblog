{%- set ccLicense = theme.creative_commons.license | lower %}
{%- set ccLanguage = theme.creative_commons.language %}
{%- set ccIcon = '<i class="fa fa-fw fa-creative-commons"></i>' %}
{%- set ccText = ccLicense | upper %}
{%- if ccLicense === 'zero' %}
  {%- set ccType = 'publicdomain/zero/1.0/' + ccLanguage %}
{% else %}
  {%- set ccType = 'licenses/' + ccLicense + '/4.0/' + ccLanguage %}
{%- endif %}
{%- set ccURL = 'https://creativecommons.org/' + ccType %}

<div>
  <ul class="post-copyright">
    <li class="post-copyright-title">
      <strong>{{ __('post.copyright.title') + __('symbol.colon') }} </strong>
      {{ page.title }}
    </li>
    <li class="post-copyright-author">
      <strong>{{ __('post.copyright.author') + __('symbol.colon') }} </strong>
      {{ post.author || author }}
      <span class="with-love" id="animate"><i class="fa fa-heart"></i></span>
    </li>
    <li class="post-copyright-release-time">
      <strong>{{ __('post.copyright.release_time') + __('symbol.colon') }} </strong>
      {{ page.date.format("YYYY年MM月DD日 - HH:MM:SS") }}
    </li>
    <li class="post-copyright-update-time">
      <strong>{{ __('post.copyright.update_time') + __('symbol.colon') }} </strong>
     {{ page.updated.format("YYYY年MM月DD日 - HH:MM:SS") }}
    </li>
    <li class="post-copyright-link">
      <strong>{{ __('post.copyright.link') + __('symbol.colon') }}</strong>
      {%- set postURL = post.url || post.permalink %}
      {{ next_url(postURL, postURL, {title: post.title}) }} &nbsp;
      <span class="copy-path" title="点击复制文章链接"><i class="fa fa-clipboard" data-clipboard-text="{{ page.permalink }}" aria-label="复制成功！"></i></span>
    </li>
    <li class="post-copyright-license">
      <strong>{{ __('post.copyright.license_title') + __('symbol.colon') }} </strong>
      {##}{{ __('post.copyright.license_content', next_url(ccURL, ccIcon + ccText)) }}{##}
    </li>
  </ul>
</div>
