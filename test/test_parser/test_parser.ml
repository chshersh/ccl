let tests =
  List.flatten
    [
      Test_error.tests;
      Test_empty.tests;
      Test_single.tests;
      Test_multiple.tests;
      Test_nested.tests;
      Test_stress.tests;
    ]
