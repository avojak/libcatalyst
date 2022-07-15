unit_test_files = [
    'Optional',
    'DigestUtils'
]

foreach name : unit_test_files
    test(name, executable(name, name + 'Test.vala', libcatalyst_sources, dependencies: libcatalyst_deps, install: false), env: ['G_TEST_SRCDIR=' + meson.current_source_dir()])
endforeach