@if(!debug && !main)

values: {
	namedConf: """
		options {
		  directory "/var/cache/bind";
		};

		logging {
		  channel default_log {
		    stderr;
		    severity info;
		    print-time yes;
		    print-severity yes;
		    print-category yes;
		  };

		  category default {
		    default_log;
		  };

		  category queries {
		    default_log;
		  };
		};

		zone "example.com" {
		  type master;
		  file "/var/lib/bind/db.example.com";
		  allow-update { none; };
		};
		"""

	zones: {
		"db.example.com": """
			$TTL 3600         ; Time-to-live (1 hour)
			@   IN  SOA   ns.example.com. admin.example.com. (
			        2025012501 ; Serial (YYYYMMDDXX format)
			        3600       ; Refresh (1 hour)
			        1800       ; Retry (30 minutes)
			        1209600    ; Expiry (2 weeks)
			        3600       ; Minimum TTL (1 hour)
			    )

			    IN  NS    ns.example.com.        ; Nameserver for the zone

			ns  IN  A     <IP of Service>        ; IP of your BIND server or DNS resolver

			*   IN  A     <IP of Service>        ; Wildcard entry for subdomains, points to ingress controller or load balancer

			"""
	}
}
