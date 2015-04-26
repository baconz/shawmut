{% set pget = salt['pillar.get'] %}

{% set conf = {
  'app_path'          : pget('ghost:app_path', '/var/www/ghost'),
  'build_path'        : pget('ghost:build_path', '/tmp/ghost/build'),
  'ghost_src'         : pget('ghost:ghost_src', 'https://ghost.org/zip/ghost-latest.zip'),
  'user_name'         : pget('ghost:user_name', 'ghost'),
  'group_name'        : pget('ghost:group_name', 'ghost'),
  'blog_url'          : pget('ghost:blog_url', 'https://elkaflame.com'),
} %}
