/*

  An example Java wrapper for a simple Python script that simply takes an
  argument and echoes it to the standard output with an exclamation mark added.

*/

import java.io.*;

public class AddExclamationMark {

    public static void main(String args[]) {
        StringBuffer result = new StringBuffer();
	String dir =  "/Users/marc/Documents/lapps/code/service_grid/wrapping-services/www/code/";
        String script = dir + "add_exclamation_mark.py";
        try {
            String[]callAndArgs = { "python", script, args[0] };
            Process p = Runtime.getRuntime().exec(callAndArgs);
            BufferedReader stdInput =
                new BufferedReader(new InputStreamReader(p.getInputStream()));
            BufferedReader stdError =
                new BufferedReader(new InputStreamReader(p.getErrorStream()));
            String st = null;
            while ((st = stdInput.readLine()) != null) {
                result.append(st); }
            while ((st = stdError.readLine()) != null) {
                System.out.println(st); }}
        catch (IOException e) {
            System.out.println("exception occured");
            e.printStackTrace(); }
        System.out.println(result.toString());
    }
}
