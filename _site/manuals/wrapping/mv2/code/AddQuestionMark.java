/*

  An example Java wrapper for a simple Python script that simply takes an
  argument and echoes it to the standard output with a question mark added.

  To run it:

  $ javac AddQuestionMark.java
  $ java -classpath . AddExlamationMark

  When used as a ServiceGrid service, you will need to make a few changes. All
  these changes are printed below as comments.
  
*/

// ADD PACKAGE DECLARATION
// package brandeis.exclamations;

import java.io.*;

// MUST IMPORT THIS WRAPPER
// import java.io.*;import jp.go.nict.langrid.wrapper.ws_1_2.AbstractLanguageService;

import java.util.Map;

// MAKE SURE THE CLASS EXTENDS A WRAPPER
// public class AddExclamationMark extends AbstractLanguageService {

public class AddQuestionMark {

    // IN THE SERVICE, THIS IS NOT USED AS A MAIN 
    // public String addExclamationMark(String args) {
    public static void main(String args[]) {

        StringBuffer result = new StringBuffer();
	String dir =  "/Users/marc/Documents/lapps/code/service_grid/wrapping-services/www/code/";
        String script = dir + "add_question_mark.py";
        
        try {
            String[]callAndArgs = { "python", script, args[0] };
            Process p = Runtime.getRuntime().exec(callAndArgs);
            BufferedReader stdInput =
                new BufferedReader(new InputStreamReader(p.getInputStream()));
            BufferedReader stdError =
                new BufferedReader(new InputStreamReader(p.getErrorStream()));
            String st = null;
            while ((st = stdInput.readLine()) != null) {
                result.append(st);
            }
            while ((st = stdError.readLine()) != null) {
                System.out.println(st);
            }
        }

        catch (IOException e) {
            System.out.println("exception occured");
            e.printStackTrace();            
        }

        // RETURN THE RESULT RATHER THAN PRINTING IT
        // return result.toString();
        System.out.println(result.toString());
    }

    
    public static void printEnvironment(String args[])
    {
        Map<String, String> env = System.getenv();
        for (String envName : env.keySet()) {
            System.out.format("%s=%s%n", envName, env.get(envName)); }
    }
}
