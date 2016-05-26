package brandeis.simpleservices;

import org.junit.Assert;
import org.junit.Test;

public class ExclamationMarkServiceTest {
	
	@Test
	public void test1() {
		String result = null;
		SimpleExclamationMarkService tp = new SimpleExclamationMarkService();
		try {
			result = tp.addMark("hello");
		} catch (Exception e) {
			e.printStackTrace(); }
		Assert.assertEquals(result, "hello!");
	}

	@Test
	public void test2() {
		String result = null;
		SimpleExclamationMarkService tp = new SimpleExclamationMarkService();
		try {
			result = tp.addMark("hello again");
		} catch (Exception e) {
			e.printStackTrace(); }
		Assert.assertEquals(result, "hello again!");
	}
}
