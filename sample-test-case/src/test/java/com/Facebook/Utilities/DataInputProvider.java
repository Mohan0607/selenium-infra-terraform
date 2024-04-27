package com.Facebook.Utilities;



import net.serenitybdd.model.environment.EnvironmentSpecificConfiguration;
import net.thucydides.model.environment.SystemEnvironmentVariables;
import net.thucydides.model.util.EnvironmentVariables;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Iterator;

public class DataInputProvider {

    private EnvironmentVariables environmentVariables;
    private String executionEnvironment;
    private String excelFilePath;
    private Workbook workbook;
    private Iterator<Row> usersIterator;
    private Iterator<Row> productsIterator;
    private Iterator<Row> addressIterator;
    private Iterator<Row> searchIterator;
    private Iterator<Row> categoryIterator;
    private Iterator<Row> couponsIterator;
    private Iterator<Row> paymentsIterator;

    public DataInputProvider() {
//        excelFilePath = System.getProperty("user.dir") + "//src//test//resources//TestData//testData_qa.xlsx";
//        System.out.println("Excel path: " + excelFilePath);
//        if (System.getProperty("environment") == null) {
//            System.setProperty("environment", "default");
//        }
//        environmentVariables = Injectors.getInjector().getInstance(EnvironmentVariables.class);
        environmentVariables = SystemEnvironmentVariables.createEnvironmentVariables();
        executionEnvironment = EnvironmentSpecificConfiguration.from(environmentVariables).getPropertyValue("execution.environment");
        System.out.println("Execution Environment is: " + executionEnvironment);

        switch (executionEnvironment) {
            case "qa":
                System.out.println("Going to get the QA test data excel path");
                excelFilePath = System.getProperty("user.dir") + "//src//test//resources//TestData//testData_qa.xlsx";
                break;
            case "uat":
                System.out.println("Going to get the UAT test data excel path");
                excelFilePath = System.getProperty("user.dir") + "//src//test//resources//TestData//testData_uat.xlsx";
                break;
            case "prod":
                excelFilePath = System.getProperty("user.dir") + "//src//test//resources//TestData//testData_prod.xlsx";
                break;
            default:
                System.out.println("Default case is executed");
        }

        try {
            FileInputStream inputStream = new FileInputStream(new File(excelFilePath));
            workbook = new XSSFWorkbook(inputStream);
        } catch (FileNotFoundException e1) {
            System.out.println("TestData file is not found");
            e1.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        Sheet readerUsers, readerProducts, readerAddress, readerSearch, readerCategory, readerCoupon, readerPayments;

        readerUsers = workbook.getSheet("users");
        readerProducts = workbook.getSheet("products");
        readerAddress = workbook.getSheet("addresses");
        readerSearch = workbook.getSheet("search");
        readerCategory = workbook.getSheet("category");
        readerCoupon = workbook.getSheet("coupons");
        readerPayments = workbook.getSheet("payments");

        usersIterator = readerUsers.iterator();
        productsIterator = readerProducts.iterator();
        addressIterator = readerAddress.iterator();
        searchIterator = readerSearch.iterator();
        categoryIterator = readerCategory.iterator();
        couponsIterator = readerCoupon.iterator();
        paymentsIterator = readerPayments.iterator();
    }

    public String getUserInfo(String userInfo) {
        String userInfo_Excel = readExcel(usersIterator, userInfo);
        System.out.println("Final User Info details: " + userInfo_Excel);
        return userInfo_Excel;

    }

    public String getProductInfo(String prodInfo) {
        String productInfo_Excel = readExcel(productsIterator, prodInfo);
        System.out.println("Final Products Info details: " + productInfo_Excel);

        return productInfo_Excel;
    }

    public String getAddressInfo(String addrInfo) {
        String addressInfo_Excel = readExcel(addressIterator, addrInfo);
        System.out.println("Final Address Info details: " + addressInfo_Excel);
        return addressInfo_Excel;

    }


    public String getSearchInfo(String searchInfo) {
        String searchInfo_Excel = readExcel(searchIterator, searchInfo);
        System.out.println("Final Search Info details: " + searchInfo_Excel);
        return searchInfo_Excel;

    }

    public String getCategoryInfo(String categoryInfo) {
        String categoryInfo_Excel = readExcel(categoryIterator, categoryInfo);
        System.out.println("Final Category Info details: " + categoryInfo_Excel);
        return categoryInfo_Excel;

    }

    public String getCouponInfo(String couponInfo) {
        String couponInfo_Excel = readExcel(couponsIterator, couponInfo);
        System.out.println("Final Coupon Info details: " + couponInfo_Excel);
        return couponInfo_Excel;

    }

    public String getPaymentInfo(String paymentInfo) {
        String paymentInfo_Excel = readExcel(paymentsIterator, paymentInfo);
        System.out.println("Final Payment Info details: " + paymentInfo_Excel);
        return paymentInfo_Excel;

    }

    public String readExcel(Iterator<Row> Iterator, String Pattern) {
        System.out.println("Pattern :"+Pattern +" Iterator :"+Iterator);
        String DetailsAll = null; //DetailsAll
        boolean foundText = false;
        while (Iterator.hasNext()) {
            Row nextRow = Iterator.next();
            Iterator<Cell> cellIterator = nextRow.cellIterator();

            while (cellIterator.hasNext()) {
                Cell cell = cellIterator.next();
                String str = cell.getStringCellValue();
                System.out.println("Value of String :"+str);
                if (str.equalsIgnoreCase(Pattern)) {
                    System.out.println("mentioned info found");

                    while (cellIterator.hasNext()) {
                        Cell DetailsCell = cellIterator.next();
                        String DetailsCell_str = null;

                        switch (DetailsCell.getCellType()) {
                            case STRING:
                                DetailsCell_str = DetailsCell.getStringCellValue();
                                break;
                            case NUMERIC:
                                DataFormatter df = new DataFormatter();
                                DetailsCell_str = df.formatCellValue(DetailsCell);
                                //double value=userDetailsCell.getNumericCellValue();
                                //userDetailsCell_str=String.valueOf(value);
                                break;
                            case BLANK:
                                DetailsCell_str = "";
                                break;

                            default:
                                System.out.println("Cell value is not String, Numeric and Blank");
                                break;
                        }

                        if (DetailsAll == null) {
                            DetailsAll = DetailsCell_str;
                            System.out.println("First value of pattern: " + DetailsAll);
                        } else {
                            DetailsAll = DetailsAll + "::" + DetailsCell_str;
                            System.out.println("New value added : " + DetailsAll);
                        }

                    }
                    System.out.println("All details of the mentioned pattern is taken form excel");
                    foundText = true;
                    // break;
                } else {
                    System.out.println("Going to the next row");
                    break;
                }

                System.out.println("Executing outer loop");
            }
            if (foundText == true) {
                System.out.println("Recorded all info details so breaking the loop");
                break;
            }
        }

        System.out.println("Final details from excel: " + DetailsAll);
        return DetailsAll;


    }

}
