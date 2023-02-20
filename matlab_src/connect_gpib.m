function y = connect_gpib(board_index, primary_address)

    obj1 = instrfind('Type', 'gpib', 'BoardIndex', board_index, ...
        'PrimaryAddress', primary_address, 'Tag', '');

    % Create the GPIB object if it does not exist
    % otherwise use the object that was found.
    if isempty(obj1)
        obj1 = gpib('KEYSIGHT', board_index, primary_address);
    else
        fclose(obj1);
        obj1 = obj1(1);
    end

    % Connect to instrument object, obj1.
    fopen(obj1);
    y = obj1;
end