unit_test_files = [
    'BigInteger',
    'ByteUtils',
    'DigestUtils',
    'EnumUtils',
    'FileUtils',
    'Http',
    'HttpUtils',
    'Optional'
]

foreach name : unit_test_files
    test(name, executable(name, name + 'Test.vala', libcatalyst_sources, config_header, dependencies: libcatalyst_deps, install: false), env: ['G_TEST_SRCDIR=' + meson.current_source_dir()])
endforeach