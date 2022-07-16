project('catalyst-1', 'vala', 'c', version: '1.0.0')

major_version = '1'
minor_version = '0'
micro_version = '0'
version_string = major_version + '.' + minor_version + '.' + micro_version

if build_machine.system() == 'linux'
    vala_os_arg = ['--define=LINUX']
elif build_machine.system() == 'dragonfly'
    vala_os_arg = ['--define=DRAGON_FLY']
elif build_machine.system() == 'freebsd'
    vala_os_arg = ['--define=FREE_BSD']
elif build_machine.system() == 'netbsd'
    vala_os_arg = ['--define=NET_BSD']
elif build_machine.system() == 'windows'
    vala_os_arg = ['--define=WINDOWS']
else
    vala_os_arg = []
endif

glib_min_version = '2.50'
if build_machine.system() == 'windows'
    gio_os_dep = dependency('gio-windows-2.0', version: '>=' + glib_min_version)
else
    gio_os_dep = dependency('gio-unix-2.0', version: '>=' + glib_min_version)
endif

add_project_arguments(
    vala_os_arg,
    '--abi-stability',
    '--hide-internal',
    '--target-glib=' + glib_min_version,
    language: ['vala']
)

libcatalyst_deps = [
    dependency('gio-2.0', version: '>=' + glib_min_version),
    gio_os_dep,
    dependency('glib-2.0', version: '>=' + glib_min_version),
    dependency('gobject-2.0', version: '>=' + glib_min_version),
    dependency('libsoup-2.4', version: '>=2.70.0'),
    dependency('gee-0.8', version: '>= 0.20.3'),
    dependency('libarchive', version: '>= 3.4.0')
]

pkgconfig = import('pkgconfig')

subdir('lib')
subdir('tests')
subdir('demo')

if get_option('documentation')
    subdir('doc')
endif