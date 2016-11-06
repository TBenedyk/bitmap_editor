require "spec_helper"
include BitmapEditorHelpers

describe BitmapEditor do

  describe "run" do

  	before(:each) do
  	  @bitmap_editor = BitmapEditor.new
  	  @counter = 0
  	  @rows = ["OOOOO","OOOOO","OOOOO","OOOOO","OOOOO","OOOOO"]
  	  @empty_rows = Marshal.load(Marshal.dump(@rows))
  	end

  	context "X command" do
      it "should terminate the session" do
        allow(@bitmap_editor).to receive(:gets).and_return("X\n")
        expect(@bitmap_editor.run).to eq(nil)
      end
    end

    context "C command" do
      it "should clear the table" do
        coloured_rows = ["AAAAA","AAAAA","AAAAA","AAAAA","AAAAA","AAAAA"]
        @bitmap_editor.instance_variable_set(:@rows, coloured_rows)
        stub_input_and_close("C")
        @bitmap_editor.run
        expect(@bitmap_editor.instance_variable_get(:@rows)).to eq(@rows)
      end
    end

    context "S command" do
      it "should show the table" do
        @bitmap_editor.instance_variable_set(:@rows, @rows)
        stub_input_and_close("S")
        allow(@bitmap_editor).to receive(:puts)
        expect(@bitmap_editor).to receive(:puts).with(@rows.join("\n"))
        @bitmap_editor.run
      end
    end

    context "? command" do
      it "should show help text" do
        stub_input_and_close("?")
        expect(@bitmap_editor).to receive(:show_help)
        @bitmap_editor.run
      end
    end

  	context "unrecognized command" do
      it "should return unrecognized message" do
        stub_input_and_close("G")
        expect(@bitmap_editor.run).to eq(false)
      end
    end

    context "I command" do
      it "should build empty bitmap with correct params" do
        stub_input_and_close("I 5 6")
        @bitmap_editor.run
        expect(@bitmap_editor.instance_variable_get(:@rows)).to eq(@rows)
      end  

      it "should not allow bitmap with more than 250 columns" do
        stub_input_and_close("I 251 6")
        @bitmap_editor.run
        expect(@bitmap_editor.instance_variable_get(:@rows)).to eq(nil)
      end  

      it "should not allow bitmap with more than 250 rows" do
        stub_input_and_close("I 5 251")
        @bitmap_editor.run
        expect(@bitmap_editor.instance_variable_get(:@rows)).to eq(nil)
      end  

      it "should not allow bitmap with less than 1 row" do
        stub_input_and_close("I 0 6")
        @bitmap_editor.run
        expect(@bitmap_editor.instance_variable_get(:@rows)).to eq(nil)
      end  

      it "should not allow bitmap with less than 1 column" do
        stub_input_and_close("I 5 0")
        @bitmap_editor.run
        expect(@bitmap_editor.instance_variable_get(:@rows)).to eq(nil)
      end
    end

    context "L command" do
      it "should colour a single pixel" do
        @bitmap_editor.instance_variable_set(:@rows, @rows)
        stub_input_and_close("L 2 3 A")
        @bitmap_editor.run
        expected_rows = ["OOOOO", "OOOOO", "OAOOO", "OOOOO", "OOOOO", "OOOOO"]
        expect(@bitmap_editor.instance_variable_get(:@rows)).to eq(expected_rows)
      end  

      it "should not colour a single pixel with param less than 1" do
        @bitmap_editor.instance_variable_set(:@rows, @rows)
        stub_input_and_close("L 2 0 A")
        @bitmap_editor.run
        expect(@bitmap_editor.instance_variable_get(:@rows)).to eq(@empty_rows)
      end
    end

    context "V command" do
      it "should draw a vertical line with correct params" do
        @bitmap_editor.instance_variable_set(:@rows, @rows)
        stub_input_and_close("V 2 3 6 W")
        @bitmap_editor.run
        expected_rows = ["OOOOO", "OOOOO", "OWOOO", "OWOOO", "OWOOO", "OWOOO"]
        expect(@bitmap_editor.instance_variable_get(:@rows)).to eq(expected_rows)
      end  

      it "should not draw vertical line if param is too low" do
        @bitmap_editor.instance_variable_set(:@rows, @rows)
        stub_input_and_close("V 2 0 6 W")
        @bitmap_editor.run
        expect(@bitmap_editor.instance_variable_get(:@rows)).to eq(@empty_rows)
      end  

      it "should not draw vertical line if param is too high" do
        @bitmap_editor.instance_variable_set(:@rows, @rows)
        stub_input_and_close("V 2 3 7 W")
        @bitmap_editor.run
        expect(@bitmap_editor.instance_variable_get(:@rows)).to eq(@empty_rows)
      end
    end

    context "H command" do
      it "should draw a horizontal line with correct params" do
        @bitmap_editor.instance_variable_set(:@rows, @rows)
        stub_input_and_close("H 3 5 2 Z")
        @bitmap_editor.run
        expected_rows = ["OOOOO", "OOZZZ", "OOOOO", "OOOOO", "OOOOO", "OOOOO"]
        expect(@bitmap_editor.instance_variable_get(:@rows)).to eq(expected_rows)
      end  

      it "should not draw horizontal line if param is too low" do
        @bitmap_editor.instance_variable_set(:@rows, @rows)
        stub_input_and_close("H 0 5 2 Z")
        @bitmap_editor.run
        expect(@bitmap_editor.instance_variable_get(:@rows)).to eq(@empty_rows)
      end  

      it "should not draw horizontal line if param is too high" do
        @bitmap_editor.instance_variable_set(:@rows, @rows)
        stub_input_and_close("H 3 6 2 Z")
        @bitmap_editor.run
        expect(@bitmap_editor.instance_variable_get(:@rows)).to eq(@empty_rows)
      end  

      it "should not draw horizontal line if row number is incorrect" do
        @bitmap_editor.instance_variable_set(:@rows, @rows)
        stub_input_and_close("H 3 5 7 Z")
        @bitmap_editor.run
        expect(@bitmap_editor.instance_variable_get(:@rows)).to eq(@empty_rows)
      end
    end

  end
	
end