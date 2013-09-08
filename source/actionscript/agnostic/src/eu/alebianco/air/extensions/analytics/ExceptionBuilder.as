/**
 * Project: ANE-Google-Analytics
 *
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 22/12/12 11.52
 *
 * Copyright © 2013 Alessandro Bianco
 */
package eu.alebianco.air.extensions.analytics {

import eu.alebianco.air.extensions.analytics.api.Hit;
import eu.alebianco.air.extensions.analytics.api.IExceptionBuilder;

internal class ExceptionBuilder implements IExceptionBuilder {

	private var tracker:Tracker;

	internal var fatal:Boolean;
	internal var description:String = null;

	public function ExceptionBuilder(tracker:Tracker, fatal:Boolean) {
		this.tracker = tracker;

		this.fatal = fatal;
	}

	public function withDescription(description:String):IExceptionBuilder {
		this.description = description.substr(0, 100);
		return this;
	}
	public function create():Hit {
		return new Exception(this);
	}

	public function track():void {
        tracker.send(create());
	}
}
}
