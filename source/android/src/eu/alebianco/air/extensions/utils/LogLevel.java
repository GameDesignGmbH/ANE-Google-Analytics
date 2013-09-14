/**
 * Project: ANE-Google-Analytics
 *
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 21/12/12 14.08
 *
 * Copyright © 2013 Alessandro Bianco
 */
package eu.alebianco.air.extensions.utils;

import android.util.Log;

public enum LogLevel {
	
	VERBOSE("VERBOSE", Log.VERBOSE),
	INFO("INFO", Log.INFO),
    WARNING("WARNING", Log.WARN),
	ERROR("ERROR", Log.ERROR);

	private final String name;
	private final int priority;
	
	private LogLevel(String n, int p)
	{
		name = n;
		priority = p;
	}
	
	public String getName()
	{
		return name;
	}
	
	public int getPriority()
	{
		return priority;
	}
}