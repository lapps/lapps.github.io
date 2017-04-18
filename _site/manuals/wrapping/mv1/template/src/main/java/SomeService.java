import java.io.*;

import org.lappsgrid.api.Data;
import org.lappsgrid.discriminator.Types;

public class SomeService implements WebService{

    public long[] requires() {
        return new long []{Types.TEXT}; }

    public long[] produces() {
        return new long []{Types.TEXT}; }

    public Data execute(Data input) {
        Data out = new Data();
        out.setDiscriminator(Types.TEXT);
        out.setPayload(input.getPayload());
        return out;
    }
}
