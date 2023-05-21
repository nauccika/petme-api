package com.petme.api;

import io.github.bonigarcia.wdm.WebDriverManager;
import java.time.Duration;
import java.util.List;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

public class SeleniumTest {

  WebDriver driver;

  @BeforeAll
  static void setupAll() {
    WebDriverManager.chromedriver().setup();
  }

  @BeforeEach
  void setup() {
    driver = getChromeDriver();
  }

  @AfterEach
  void teardown() {
    driver.quit();
  }

  public static ChromeDriver getChromeDriver() {
    ChromeOptions chromeOptions = new ChromeOptions();
    chromeOptions.addArguments("--start-maximized");
    chromeOptions.addArguments("--remote-allow-origins=*");
    return new ChromeDriver(chromeOptions);
  }

  @Test
  public void crawlFromNaver() {

    driver.get("https://map.naver.com/v5/search/병원");
    driver.manage().timeouts().implicitlyWait(Duration.ofMillis(1000));

    System.out.println("driver = " + driver.getTitle());
    driver.switchTo().frame(driver.findElement(By.cssSelector("iframe#searchIframe")));


    List<WebElement> elements = driver.findElements(By.cssSelector(".C6RjW>.place_bluelink"));

    System.out.println("TestTest**********************************");
    System.out.println("elements.size() = " + elements.size());
    elements.get(0).click();

    driver.manage().timeouts().implicitlyWait(Duration.ofMillis(500));
    driver.switchTo().defaultContent();
    driver.manage().timeouts().implicitlyWait(Duration.ofMillis(3000));
    driver.switchTo().frame(driver.findElement(By.cssSelector("iframe#entryIframe")));


    List<WebElement> placeSectionContents = driver.findElements(By.cssSelector(".place_section_content"));
    WebElement menuElement = placeSectionContents.get(placeSectionContents.size() - 1);
    List<WebElement> menus = menuElement.findElements(By.cssSelector("ul>li"));

    System.out.println("menumenu*******************************************");
    System.out.println("menus.size() = " + menus.size());

    for (WebElement menu : menus) {
      System.out.println(menu.getText());
    }
  }
}
