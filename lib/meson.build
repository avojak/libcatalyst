libcatalyst_sources = files(
    'BigInteger.vala',
    'DigestUtils.vala',
    'DownloadContext.vala',
    'FileUtils.vala',
    'HttpUtils.vala',
    'Optional.vala',
    'Supplier.vala'
)

# Define all the names and versions
catalyst_gi_name = 'Catalyst'
catalyst_gi_version = '1.0.0'

catalyst_gi = catalyst_gi_name + '-' + catalyst_gi_version
catalyst_gir = catalyst_gi + '.gir'
catalyst_typelib = catalyst_gi + '.typelib'

include_dir = join_paths(
    get_option('prefix'),
    get_option('includedir'),
    meson.project_name()
)

libcatalyst = library(
    meson.project_name (),

    libcatalyst_sources,

    dependencies: [
        libcatalyst_deps
    ],

    vala_header: 'catalyst-1.h',
    vala_vapi: 'catalyst-1.vapi',
    vala_gir: catalyst_gir,

    version: meson.project_version(),
    install: true,
    install_dir: [true, include_dir, true, true]
)

install_data(
    'catalyst-1.deps',
    install_dir: join_paths(get_option('datadir'), 'vala', 'vapi')
)

if get_option('introspection')
    g_ir_compiler = find_program('g-ir-compiler')
    custom_target(
        catalyst_typelib,
        command: [
            g_ir_compiler,
            '--shared-library',
            '@PLAINNAME@',
            '--output',
            '@OUTPUT@',
            join_paths(meson.current_build_dir(), catalyst_gir),
        ],
        input: libcatalyst,
        output: catalyst_typelib,
        depends: libcatalyst,
        install: true,
        install_dir: join_paths(get_option('libdir'), 'girepository-1.0'),
    )
endif

libcatalyst_dep = declare_dependency(
    link_with: libcatalyst,
    dependencies: libcatalyst_deps,
    include_directories: [include_directories('.')]
)

# generate pkgconfig file
catalyst_pc = pkgconfig.generate(
    libcatalyst,
    name: meson.project_name(),
    requires: libcatalyst_deps,
    subdirs: ['catalyst-1'],
    description: 'GLib utility library',
    version: meson.project_version(),
    url: 'https://github.com/avojak/catalyst',
)