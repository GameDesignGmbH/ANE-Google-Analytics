/**
 * Project: ANE-Google-Analytics
 *
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 21/12/12 17.14
 *
 * Copyright © 2013 Alessandro Bianco
 */
package eu.alebianco.air.extensions.analytics {

import eu.alebianco.core.Enum;

public class LogLevel extends Enum {
	{
		initEnum(LogLevel);
	}

	public static const VERBOSE:LogLevel = new LogLevel(logStatusLevel);
	public static const INFO:LogLevel = new LogLevel(logStatusLevel);
	public static const WARNING:LogLevel = new LogLevel(logStatusLevel);
	public static const ERROR:LogLevel = new LogLevel(logStatusLevel);

	public static function getConstants():Vector.<LogLevel> {
		return Vector.<LogLevel>(Enum.getConstants(LogLevel));
	}
	public static function parseConstant(constantName:String, caseSensitive:Boolean = false):LogLevel {
		return LogLevel(Enum.parseConstant(LogLevel, constantName, caseSensitive));
	}

	private var _ns:Namespace;

	public function LogLevel(ns:Namespace) {
		super();
		_ns = ns;
	}

	internal function get ns():Namespace {
		return _ns;
	}

	override public function toString():String {
		return "[Status level (name: " + name + ")]";
	}
}
}