valadoc = find_program('valadoc')

valadoc_vala_dir = 'catalyst-' + major_version + '-vala'
valadoc_target = custom_target(
    'valadoc',
    command: [
        valadoc,
        '--pkg=gio-2.0',
        '--pkg=glib-2.0',
        '--pkg=gobject-2.0',
        '--pkg=libsoup-3.0',
        '--pkg=gee-0.8',
        '--pkg=libarchive',
        libcatalyst_sources,
        config_header,
        '--target-glib=' + glib_min_version,
        '--package-name=' + meson.project_name(),
        '--package-version=' + meson.project_version(),
        '--verbose',
        '--force',
        '-o', join_paths(meson.current_build_dir(), valadoc_vala_dir)
    ],
    build_by_default: true,
    output: valadoc_vala_dir,
    depends: libcatalyst
)

valadoc_c_dir = 'catalyst-' + major_version
cdoc_target = custom_target(
    'cdocs',
    command: [
        valadoc,
        '--pkg=gio-2.0',
        '--pkg=glib-2.0',
        '--pkg=gobject-2.0',
        '--pkg=libsoup-3.0',
        '--pkg=gee-0.8',
        '--pkg=libarchive',
        libcatalyst_sources,
        config_header,
        '--target-glib=' + glib_min_version,
        '--package-name=' + meson.project_name(),
        '--package-version=' + meson.project_version(),
        '--verbose',
        '--force',
        '-o', join_paths(meson.current_build_dir(), valadoc_c_dir),
        '--doclet-arg=' + 'lib/catalyst-' + major_version + '.h'
    ],
    build_by_default: true,
    output: valadoc_c_dir,
    depends: libcatalyst
)