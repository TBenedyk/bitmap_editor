module BitmapEditorHelpers

  def stub_input_and_close(input)
    allow(@bitmap_editor).to receive(:gets) do
      response = @counter == 0 ? "#{input}\n" : "X\n"
      @counter += 1
      response
    end
  end

end
