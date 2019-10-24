package ml.dmlc.xgboost4j;

import java.io.Serializable;

public final class LabeledPoint implements Serializable {
  private static final long serialVersionUID = -8258523529185099548L;

  private final float label;
  private final int[] indices;
  private final float[] values;
  private float weight = 1.f;

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

}