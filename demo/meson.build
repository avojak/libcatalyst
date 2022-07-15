executable(
    'catalyst-1-demo',

    'CatalystDemo.vala',
    join_paths('Views', 'DigestView.vala'),
    join_paths('Views', 'HttpView.vala'),

    dependencies: [
        libcatalyst_dep,
        dependency('gtk+-3.0', version: '>= 3.6.4')
    ],

    install: true,
)

applications_dir = join_paths(
    get_option('prefix'),
    get_option('datadir'),
    'applications'
)

install_data(
    'com.github.avojak.catalyst-1.demo.desktop',
    install_dir: applications_dir
)