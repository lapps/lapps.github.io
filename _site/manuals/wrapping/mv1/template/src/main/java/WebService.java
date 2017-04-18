import org.lappsgrid.api.Data;

public interface WebService {
  /**
   * Returns the set of data types that must be present in the
   * input to the {@link #execute(Data)} method
   */
  long[] requires();

  /**
   * Returns the set of data types that will be included in the output.
   */
  long[] produces();

  /**
   * Executes a web service on the given input. Returns the output, if any,
   * of the web service in a {@link Data} object.
   */
  Data execute(Data input);
}
