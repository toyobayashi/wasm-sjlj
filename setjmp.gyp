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
      'link_settings': {
        'ldflags': [
          '-mllvm', '-wasm-enable-sjlj',
        ],
        'xcode_settings': {
          'OTHER_LDFLAGS': [
            '-mllvm', '-wasm-enable-sjlj',
          ],
        },
      },
    },
  ]
}
