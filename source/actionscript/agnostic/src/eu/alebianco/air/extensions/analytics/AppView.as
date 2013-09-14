/**
 * Project: ANE-Google-Analytics
 *
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 22/12/12 0.22
 *
 * Copyright © 2013 Alessandro Bianco
 */
package eu.alebianco.air.extensions.analytics {

import eu.alebianco.air.extensions.analytics.api.Hit;

internal class AppView implements Hit {

	private var _screen:String;

    public function get type():HitType {
        return HitType.APP_VIEW;
    }

    public function AppView(builder:AppViewBuilder) {
		_screen = builder.screen;
	}

	public function get screen():String {
		return _screen;
	}
}
}
