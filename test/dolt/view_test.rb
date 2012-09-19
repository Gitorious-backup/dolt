# encoding: utf-8
#--
#   Copyright (C) 2012 Gitorious AS
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
require "test_helper"
require "dolt/view"
require "dolt/merger"

describe Dolt::View do
  describe "#load_all" do
    it "loads all helpers" do
      helpers = Dolt::Merger.new(Dolt::View.load_all)

      assert helpers.respond_to?(:object_url)
      assert helpers.respond_to?(:blame_url)
      assert helpers.respond_to?(:breadcrumb)
    end
  end
end
