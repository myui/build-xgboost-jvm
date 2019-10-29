/*
 Copyright (c) 2014 by Contributors

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

package ml.dmlc.xgboost4j;

import java.io.Serializable;

/**
 * Labeled training data point.
 */
public class LabeledPoint implements Serializable {
  private static final long serialVersionUID = -8258523529185099548L;

  private float label;
  private int[] indices;
  private float[] values;
  private float weight = 1.f;
  private int group = -1;
  private float baseMargin = Float.NaN;

  public LabeledPoint(float label, int[] indices, float[] values) {
    if (indices == null || values == null) {
      throw new IllegalArgumentException("indices and values must not be null");
    }
    if (indices.length != values.length) {
      throw new IllegalArgumentException(
        "indices and values must have the same number of elements");
    }
    this.label = label;
    this.indices = indices;
    this.values = values;
  }

  public float label() {
    return label;
  }

  public int[] indices() {
    return indices;
  }

  public float[] values() {
    return values;
  }

  public float weight() {
    return weight;
  }

  public int group() {
    return group;
  }

  public float baseMargin() {
    return baseMargin;
  }

}