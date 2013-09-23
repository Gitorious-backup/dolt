# encoding: utf-8
#--
#   Copyright (C) 2013 Gitorious AS
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++
require "sinatra/base"
require "dolt/sinatra/actions"
require "libdolt/view/blob"
require "libdolt/view/tree"

module Dolt
  module Sinatra
    class RepoBrowser < ::Sinatra::Base
      include Dolt::View::Blob
      include Dolt::View::Tree

      not_found { renderer.render("404") }

      def initialize(lookup, renderer)
        @lookup = lookup
        @renderer = renderer
        super()
      end

      private

      attr_reader :lookup, :renderer

      def dolt
        @dolt ||= Dolt::Sinatra::Actions.new(self, lookup, renderer)
      end

    end
  end
end
