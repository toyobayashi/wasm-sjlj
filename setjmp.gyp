{
  'targets': [
    {
      'target_name': 'setjmp',
      'type': 'static_library',
      'defines': [
        '__EMSCRIPTEN__',
        '__USING_WASM_SJLJ__',
      ],
      'sources': [
        'src/emscripten_setjmp.c',
        'src/emscripten_tempret.s',
      ],
      'include_dirs': [
        './include',
      ],
      'all_dependent_settings': {
        'include_dirs': ['./include'],
        'cflags': [
          '-mllvm', '-wasm-enable-sjlj',
        ],
        'xcode_settings': {
          'WARNING_CFLAGS': [
            '-mllvm', '-wasm-enable-sjlj',
          ],
        },
      },
    },
  ]
}
