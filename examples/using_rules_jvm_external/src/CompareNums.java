// Copyright 2021 VMware, Inc.
// SPDX-License-Identifier: Apache-2.0

import com.google.common.primitives.Ints;

/**
 * This application compares two numbers, using the Ints.compare
 * method from Guava.
 */
public class CompareNums {

  public static int compare(int a, int b) {
    return Ints.compare(a, b);
  }

  public static void main(String... args) throws Exception {
    CompareNums app = new CompareNums();
    System.out.println("Success: " + app.compare(2, 1));
  }

}
