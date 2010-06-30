package com.yalespector.code.test;

import android.app.Activity;
import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.view.View;
import android.view.View.OnClickListener;

public class SimpleDemo extends Activity implements OnClickListener {
    /** Called when the activity is first created. */
	
	Button toF;
	Button toC;
    EditText e;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
    	toF = (Button) findViewById(R.id.convertToFarenheit);
    	toC = (Button) findViewById(R.id.convertToCelcius);
        e = (EditText) findViewById(R.id.UserInput);
        
        toF.setOnClickListener(this);
        toC.setOnClickListener(this);
    }
    
    
    
    public void onClick(View v) {
    	int vId = v.getId();
    	String t = e.getText().toString();
    	double td = Double.parseDouble(t);
    	if (vId == toF.getId()) {
        	e.setText(String.valueOf(9 * td / 5 + 32));
    	} else if (vId == toC.getId()) {
    		e.setText(String.valueOf(5 * (td - 32) / 9));
    	}
    }
}
