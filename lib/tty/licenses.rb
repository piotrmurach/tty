# frozen_string_literal: true

module TTY
  module Licenses
    CUSTOM = "custom"

    LICENSES = {
      "agplv3" => { name: "AGPL-3.0",
                    desc: "GNU Affero General Public License v3.0" },
      "apache" => { name: "Apache-2.0", desc: "Apache License 2.0" },
      "bsd2"   => { name: "BSD-2-Clause",
                    desc: "BSD 2-Clause License (FreeBSD/Simplified)" },
      "bsd3"   => { name: "BSD-3-Clause",
                    desc: "BSD 3-Clause License (Revised)" },
      "gplv2"  => { name: "GPL-2.0",
                    desc: "GNU General Public License v2.0" },
      "gplv3"  => { name: "GPL-3.0",
                    desc: "GNU General Public License v3.0" },
      "lgplv3" => { name: "LGPL-3.0",
                    desc: "GNU Lesser General Public License v3.0" },
      "mit"    => { name: "MIT", desc: "MIT License" },
      "mplv2"  => { name: "MPL-2.0", desc: "Mozilla Public License 2.0" }
    }.freeze

    def licenses
      LICENSES
    end

    def license_identifiers
      licenses.values.map { |key, val| val if key == :name }
    end
  end # Licenses
end # TTY
