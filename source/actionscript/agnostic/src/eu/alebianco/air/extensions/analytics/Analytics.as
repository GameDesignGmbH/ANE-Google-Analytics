/**
 * Project: ANE-Google-Analytics
 *
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 21/12/12 16.22
 *
 * Copyright © 2013 Alessandro Bianco
 */
package eu.alebianco.air.extensions.analytics {

import eu.alebianco.air.extensions.analytics.api.IAnalytics;
import eu.alebianco.air.extensions.analytics.api.ITracker;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import mx.logging.ILogger;
import mx.logging.Log;

public final class Analytics implements IAnalytics {

	private static const EXTENSION_ID:String = "eu.alebianco.air.extensions.analytics.NativeGATracker";
	private static const ID_VALIDATOR:RegExp = /^UA-\d{4,10}-\d{1,4}$/i;

	private static var instance:Analytics;
	private static var canBuild:Boolean;

	private var logger:ILogger;

	private var context:ExtensionContext;
	private var trackers:Dictionary;

	public static function getInstance():Analytics {
		if (!instance) {
			canBuild = true;
			instance = new Analytics();
			canBuild = false;
		}
		return instance;
	}

	public static function isSupported():Boolean {
		var c:ExtensionContext = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
		var result:Boolean = c.call("isSupported") as Boolean;
		c.dispose();
		return result;
	}

	public function Analytics() {
		if (!canBuild)
			throw new Error("Can't instantiate a Singleton class, use getInstance() to get a reference.");

		if (!context) {
			context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
			context.addEventListener(StatusEvent.STATUS, statusHandler);
		}

		trackers = new Dictionary();

		var className:String = getQualifiedClassName(this).replace("::", ".");
		logger = Log.getLogger(className);
	}

	public function get version():String {
		return handleResultFromExtension(context.call("getVersion"), String);
	}

	public function get optOut():Boolean {
		return handleResultFromExtension(context.call("getOptOut"), Boolean) as Boolean;
	}

	public function set optOut(value:Boolean):void {
		handleResultFromExtension(context.call("setOptOut", value));
	}

	public function get dryRun():Boolean {
		return handleResultFromExtension(context.call("getDryRun")) as Boolean;
	}

	public function set dryRun(value:Boolean):void {
		handleResultFromExtension(context.call("setDryRun", value));
	}

	public function hasTracker(trackingId:String):Boolean {
		if (!ID_VALIDATOR.test(trackingId))
			throw new ArgumentError("The provided tracking ID (" + trackingId + ") is invalid, it should follow the format UA-00000-0.");

		return trackingId in trackers;
	}

	public function getTracker(trackingId:String):ITracker {
		if (!ID_VALIDATOR.test(trackingId))
			throw new ArgumentError("The provided tracking ID (" + trackingId + ") is invalid, it should follow the format UA-00000-0.");

		var tracker:ITracker;
		if (trackingId in trackers) {
			tracker = trackers[trackingId];
		} else {
			handleResultFromExtension(context.call("createTracker", trackingId));
			tracker = new Tracker(trackingId, context);
			trackers[trackingId] = tracker;
		}
		return tracker;
	}

	public function closeTracker(trackingId:String):void {
		if (!ID_VALIDATOR.test(trackingId))
			throw new ArgumentError("The provided tracking ID (" + trackingId + ") is invalid, it should follow the format UA-00000-0.");

		if (trackingId in trackers) {
			var tracker:ITracker = trackers[trackingId];
			tracker.dispose();
			trackers[trackingId] = null;
			delete trackers[trackingId];
		}
	}

	public function dispose():void {
		disposeAllTrackers();
		context.dispose();
		context.removeEventListener(StatusEvent.STATUS, statusHandler);
		context = null;
		logger = null;
		trackers = null;
		instance = null;
	}

	private function disposeAllTrackers():void {
		for (var id:String in trackers) {
			var tracker:ITracker = trackers[id];
			tracker.dispose();
			trackers[id] = null;
			delete trackers[id];
		}
	}

	private function statusHandler(event:StatusEvent):void {
		var level:StatusLevel = StatusLevel.parseConstant(event.level);
		if (level) {
			var ns:Namespace = level.ns;
			ns::processStatusEvent(level.name, event.code);
		}
	}

	logStatusLevel function processStatusEvent(level:String, code:String):void {
		switch (level.toUpperCase()) {
			case "INFO":
				logger.info(code);
				break;
			case "DEBUG":
				logger.debug(code);
				break;
			case "WARN":
				logger.warn(code);
				break;
			case "ERROR":
				logger.error(code);
				break;
			case "FATAL":
				logger.fatal(code);
				break;
			default:
				logger.debug("AsyncStatusEvent level (" + level + ") unknown.");
				break;
		}
	}
}
}
